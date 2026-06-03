import 'dart:async';
import 'dart:convert';

import 'package:beach_talk/features/voice_conversation/realtime_voice_service.dart';
import 'package:beach_talk/features/voice_conversation/voice_conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('RealtimeApiClient parses client secrets from the API', () async {
    final client = RealtimeApiClient(
      baseUri: Uri.parse('http://localhost:3000'),
      httpClient: MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/realtime/client-secret');

        return http.Response(
          jsonEncode({
            'clientSecret': 'ephemeral-secret',
            'expiresAt': 123,
          }),
          200,
          headers: {'Content-Type': 'application/json'},
        );
      }),
    );

    final session = await client.createClientSecret();

    expect(session.clientSecret, 'ephemeral-secret');
    expect(session.expiresAt, 123);
  });

  testWidgets('VoiceConversationPage starts and ends a voice session', (
    tester,
  ) async {
    final service = RealtimeVoiceService(
      apiClient: _FakeRealtimeApiClient(),
      transport: _FakeRealtimeTransport(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: VoiceConversationPage(service: service),
      ),
    );

    expect(find.text('desconectado'), findsOneWidget);

    await tester.tap(find.text('iniciar conversa'));
    await tester.pump();
    expect(find.text('conectando'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('conversando'), findsOneWidget);

    await tester.tap(find.text('encerrar conversa'));
    await tester.pumpAndSettle();

    expect(find.text('desconectado'), findsOneWidget);
  });

  test('RealtimeVoiceService cleans up transport when connection fails', () async {
    final transport = _FailingRealtimeTransport();
    final service = RealtimeVoiceService(
      apiClient: _FakeRealtimeApiClient(),
      transport: transport,
    );

    await service.start();

    expect(service.status, VoiceConversationStatus.error);
    expect(transport.disconnectCount, 1);
  });

  test('RealtimeVoiceService can stop while connecting', () async {
    final transport = _SlowRealtimeTransport();
    final service = RealtimeVoiceService(
      apiClient: _FakeRealtimeApiClient(),
      transport: transport,
    );

    final startFuture = service.start();
    await Future<void>.delayed(Duration.zero);

    final stopFuture = service.stop();
    transport.completeConnect();

    await startFuture;
    await stopFuture;

    expect(service.status, VoiceConversationStatus.disconnected);
    expect(transport.disconnectCount, 1);
  });

  test('RealtimeVoiceService does not connect after stop during token request', () async {
    final apiClient = _SlowRealtimeApiClient();
    final transport = _CountingRealtimeTransport();
    final service = RealtimeVoiceService(
      apiClient: apiClient,
      transport: transport,
    );

    final startFuture = service.start();
    await Future<void>.delayed(Duration.zero);

    final stopFuture = service.stop();
    apiClient.completeRequest();

    await startFuture;
    await stopFuture;

    expect(service.status, VoiceConversationStatus.disconnected);
    expect(transport.connectCount, 0);
  });
}

class _FakeRealtimeApiClient extends RealtimeApiClient {
  _FakeRealtimeApiClient()
      : super(
          baseUri: Uri.parse('http://localhost:3000'),
          httpClient: MockClient((_) async => http.Response('{}', 200)),
        );

  @override
  Future<RealtimeSession> createClientSecret() async {
    await Future<void>.delayed(Duration.zero);
    return const RealtimeSession(
      clientSecret: 'fake-secret',
      expiresAt: 123,
    );
  }
}

class _FakeRealtimeTransport implements RealtimeTransport {
  @override
  Future<void> connect(String clientSecret) async {
    expect(clientSecret, 'fake-secret');
    await Future<void>.delayed(Duration.zero);
  }

  @override
  Future<void> disconnect() async {}
}

class _FailingRealtimeTransport implements RealtimeTransport {
  var disconnectCount = 0;

  @override
  Future<void> connect(String clientSecret) {
    throw const RealtimeVoiceException('connect failed');
  }

  @override
  Future<void> disconnect() async {
    disconnectCount++;
  }
}

class _SlowRealtimeTransport implements RealtimeTransport {
  final _connectCompleter = Completer<void>();
  var disconnectCount = 0;

  @override
  Future<void> connect(String clientSecret) {
    return _connectCompleter.future;
  }

  void completeConnect() {
    _connectCompleter.complete();
  }

  @override
  Future<void> disconnect() async {
    disconnectCount++;
  }
}

class _SlowRealtimeApiClient extends RealtimeApiClient {
  _SlowRealtimeApiClient()
      : super(
          baseUri: Uri.parse('http://localhost:3000'),
          httpClient: MockClient((_) async => http.Response('{}', 200)),
        );

  final _requestCompleter = Completer<RealtimeSession>();

  @override
  Future<RealtimeSession> createClientSecret() {
    return _requestCompleter.future;
  }

  void completeRequest() {
    _requestCompleter.complete(
      const RealtimeSession(clientSecret: 'fake-secret'),
    );
  }
}

class _CountingRealtimeTransport implements RealtimeTransport {
  var connectCount = 0;

  @override
  Future<void> connect(String clientSecret) async {
    connectCount++;
  }

  @override
  Future<void> disconnect() async {}
}
