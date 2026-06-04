import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;

enum VoiceConversationStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error,
}

class RealtimeSession {
  const RealtimeSession({
    required this.clientSecret,
    this.expiresAt,
  });

  final String clientSecret;
  final int? expiresAt;
}

class RealtimeApiClient {
  RealtimeApiClient({
    required this.baseUri,
    this.appToken = const String.fromEnvironment('BEACH_TALK_APP_TOKEN'),
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  final Uri baseUri;
  final String appToken;
  final http.Client _httpClient;

  Future<RealtimeSession> createClientSecret() async {
    final response = await _httpClient.post(
      baseUri.resolve('/realtime/client-secret'),
      headers: {
        if (appToken.isNotEmpty) 'x-beach-talk-app-token': appToken,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RealtimeVoiceException(
        'API returned ${response.statusCode}: ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final clientSecret = body['clientSecret'] as String?;
    if (clientSecret == null || clientSecret.isEmpty) {
      throw const RealtimeVoiceException('API did not return a client secret');
    }

    return RealtimeSession(
      clientSecret: clientSecret,
      expiresAt: body['expiresAt'] as int?,
    );
  }
}

abstract class RealtimeTransport {
  Future<void> connect(String clientSecret);

  Future<void> disconnect();
}

class WebRtcRealtimeTransport implements RealtimeTransport {
  WebRtcRealtimeTransport({
    http.Client? httpClient,
    Uri? realtimeCallUri,
  })  : _httpClient = httpClient ?? http.Client(),
        _realtimeCallUri = realtimeCallUri ??
            Uri.parse('https://api.openai.com/v1/realtime/calls');

  final http.Client _httpClient;
  final Uri _realtimeCallUri;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCDataChannel? _dataChannel;
  // Plays the assistant's audio. Without an attached sink the remote track is
  // silent on mobile browsers, which block WebRTC autoplay (desktop does not).
  RTCVideoRenderer? _remoteRenderer;

  @override
  Future<void> connect(String clientSecret) async {
    try {
      final peerConnection = await createPeerConnection({
        'sdpSemantics': 'unified-plan',
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ],
      });
      _peerConnection = peerConnection;

      final remoteRenderer = RTCVideoRenderer();
      await remoteRenderer.initialize();
      _remoteRenderer = remoteRenderer;

      // Attach the assistant's audio track so it actually plays. Triggered
      // inside the user's "start" gesture, so mobile autoplay policies allow it.
      peerConnection.onTrack = (RTCTrackEvent event) {
        if (event.streams.isNotEmpty) {
          remoteRenderer.srcObject = event.streams.first;
        }
      };

      final localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': false,
      });
      _localStream = localStream;

      for (final track in localStream.getTracks()) {
        await peerConnection.addTrack(track, localStream);
      }

      _dataChannel = await peerConnection.createDataChannel(
        'oai-events',
        RTCDataChannelInit()..ordered = true,
      );

      final offer = await peerConnection.createOffer({});
      await peerConnection.setLocalDescription(offer);

      final response = await _httpClient.post(
        _realtimeCallUri,
        headers: {
          'Authorization': 'Bearer $clientSecret',
          'Content-Type': 'application/sdp',
        },
        body: offer.sdp,
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw RealtimeVoiceException(
          'OpenAI Realtime call failed with ${response.statusCode}: '
          '${response.body}',
        );
      }

      await peerConnection.setRemoteDescription(
        RTCSessionDescription(response.body, 'answer'),
      );
    } catch (_) {
      await disconnect();
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    await _dataChannel?.close();
    _dataChannel = null;

    final stream = _localStream;
    if (stream != null) {
      for (final track in stream.getTracks()) {
        await track.stop();
      }
      await stream.dispose();
      _localStream = null;
    }

    await _peerConnection?.close();
    _peerConnection = null;

    final renderer = _remoteRenderer;
    if (renderer != null) {
      renderer.srcObject = null;
      await renderer.dispose();
      _remoteRenderer = null;
    }
  }
}

class RealtimeVoiceService extends ChangeNotifier {
  RealtimeVoiceService({
    RealtimeApiClient? apiClient,
    RealtimeTransport? transport,
  })  : _apiClient = apiClient ??
            RealtimeApiClient(baseUri: defaultRealtimeApiBaseUri()),
        _transport = transport ?? WebRtcRealtimeTransport();

  final RealtimeApiClient _apiClient;
  final RealtimeTransport _transport;

  VoiceConversationStatus status = VoiceConversationStatus.disconnected;
  String? errorMessage;
  Future<void>? _startOperation;
  bool _stopRequested = false;
  bool _disposed = false;

  Future<void> start() async {
    if (status == VoiceConversationStatus.connecting ||
        status == VoiceConversationStatus.connected) {
      return _startOperation;
    }

    _stopRequested = false;
    final operation = _start();
    _startOperation = operation;
    await operation;
    _startOperation = null;
  }

  Future<void> _start() async {
    _setStatus(VoiceConversationStatus.connecting);

    try {
      final session = await _apiClient.createClientSecret();
      if (_stopRequested || _disposed) {
        errorMessage = null;
        _setStatus(VoiceConversationStatus.disconnected);
        return;
      }
      await _transport.connect(session.clientSecret);
      if (_stopRequested || _disposed) {
        await _transport.disconnect();
        errorMessage = null;
        _setStatus(VoiceConversationStatus.disconnected);
        return;
      }
      errorMessage = null;
      _setStatus(VoiceConversationStatus.connected);
    } catch (error) {
      await _transport.disconnect();
      if (_stopRequested || _disposed) {
        errorMessage = null;
        _setStatus(VoiceConversationStatus.disconnected);
        return;
      }
      errorMessage = error is RealtimeVoiceException
          ? error.message
          : 'Não foi possível iniciar a conversa.';
      _setStatus(VoiceConversationStatus.error);
    }
  }

  Future<void> stop() async {
    if (status == VoiceConversationStatus.connecting) {
      _stopRequested = true;
      await _startOperation;
      return;
    }

    if (status != VoiceConversationStatus.connected &&
        status != VoiceConversationStatus.error) {
      return;
    }

    _setStatus(VoiceConversationStatus.disconnecting);
    await _transport.disconnect();
    errorMessage = null;
    _setStatus(VoiceConversationStatus.disconnected);
  }

  void _setStatus(VoiceConversationStatus nextStatus) {
    status = nextStatus;
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _stopRequested = true;
    unawaited(_transport.disconnect());
    super.dispose();
  }
}

class RealtimeVoiceException implements Exception {
  const RealtimeVoiceException(this.message);

  final String message;

  @override
  String toString() => message;
}

Uri defaultRealtimeApiBaseUri() {
  const configured = String.fromEnvironment('BEACH_TALK_API_URL');
  if (configured.isNotEmpty) {
    return Uri.parse(configured);
  }

  // On web the API is served from the same origin as the page, so calls are
  // relative — no CORS, no hardcoded host.
  if (kIsWeb) {
    return Uri.base;
  }

  // Android emulator reaches the host machine through 10.0.2.2; other native
  // platforms fall back to localhost (overridden by BEACH_TALK_API_URL).
  if (defaultTargetPlatform == TargetPlatform.android) {
    return Uri.parse('http://10.0.2.2:3000');
  }

  return Uri.parse('http://localhost:3000');
}
