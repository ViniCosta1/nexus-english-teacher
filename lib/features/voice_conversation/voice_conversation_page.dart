import 'package:flutter/material.dart';

import '../../components/racket_orb.dart';
import 'realtime_voice_service.dart';

class VoiceConversationPage extends StatefulWidget {
  const VoiceConversationPage({
    super.key,
    this.service,
  });

  final RealtimeVoiceService? service;

  @override
  State<VoiceConversationPage> createState() => _VoiceConversationPageState();
}

class _VoiceConversationPageState extends State<VoiceConversationPage> {
  late final RealtimeVoiceService _service =
      widget.service ?? RealtimeVoiceService();

  bool get _ownsService => widget.service == null;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceChanged);
    if (_ownsService) {
      _service.dispose();
    }
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _service.status == VoiceConversationStatus.connected;
    final isBusy = _service.status == VoiceConversationStatus.connecting ||
        _service.status == VoiceConversationStatus.disconnecting;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        title: const Text('Teacher da Fer'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: RacketOrb(size: 180)),
              const SizedBox(height: 32),
              Text(
                _statusLabel(_service.status),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFBFA7FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Converse em inglês com sua professora IA.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ela vai responder em inglês, corrigir sua pronúncia e sugerir formas naturais de falar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
              if (_service.errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _service.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ],
              const Spacer(),
              OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : isConnected
                        ? _service.stop
                        : _service.start,
                icon: Icon(isConnected ? Icons.stop : Icons.mic_none),
                label: Text(
                  isConnected ? 'Encerrar conversa' : 'Iniciar conversa',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: Color(0xFFE7E7E7)),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isConnected
                    ? 'Fale em inglês. A IA responderá por voz e dará dicas curtas.'
                    : 'Configure a API em http://localhost:3000 para iniciar a sessão.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(VoiceConversationStatus status) {
    return switch (status) {
      VoiceConversationStatus.disconnected => 'desconectado',
      VoiceConversationStatus.connecting => 'conectando',
      VoiceConversationStatus.connected => 'conversando',
      VoiceConversationStatus.disconnecting => 'encerrando',
      VoiceConversationStatus.error => 'erro',
    };
  }
}
