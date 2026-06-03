import 'package:flutter/material.dart';

import 'phrase.dart';
import 'phrase_speech_service.dart';

class PhraseDetailPage extends StatefulWidget {
  const PhraseDetailPage({
    required this.phrase,
    this.speechService,
    super.key,
  });

  final Phrase phrase;
  final PhraseSpeechService? speechService;

  @override
  State<PhraseDetailPage> createState() => _PhraseDetailPageState();
}

class _PhraseDetailPageState extends State<PhraseDetailPage> {
  late final PhraseSpeechService _speechService =
      widget.speechService ?? PhraseSpeechService();

  var _isSpeaking = false;
  String? _speechError;

  Future<void> _speakPhrase() async {
    setState(() {
      _isSpeaking = true;
      _speechError = null;
    });

    try {
      await _speechService.speak(widget.phrase.text);
    } catch (_) {
      _speechError = 'Não foi possível tocar a frase agora.';
    } finally {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        title: const Text('Detalhe da frase'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              widget.phrase.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: 'Significado',
              child: Text(
                widget.phrase.meaningPtBr,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Pronuncia',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.phrase.pronunciationHint,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: _isSpeaking ? null : _speakPhrase,
                    icon: Icon(_isSpeaking ? Icons.hourglass_empty : Icons.volume_up),
                    label: Text(_isSpeaking ? 'gerando áudio...' : 'ouvir frase'),
                  ),
                  if (_speechError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _speechError!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Exemplos',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final example in widget.phrase.examples)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        example,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.35,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3A3A3A)),
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF181818),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFBFA7FF),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
