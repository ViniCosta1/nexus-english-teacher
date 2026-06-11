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
    final phrase = widget.phrase;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        title: const Text('Detalhe da frase'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  phrase.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 24),
                _SectionCard(
                  title: 'Significado',
                  child: Text(
                    phrase.meaningPtBr,
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
                        phrase.pronunciationHint,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _isSpeaking ? null : _speakPhrase,
                        icon: Icon(
                          _isSpeaking ? Icons.hourglass_empty : Icons.volume_up,
                        ),
                        label: Text(
                          _isSpeaking ? 'Gerando áudio...' : 'Ouvir frase',
                        ),
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
                if (phrase.words.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Palavra por palavra',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final pw in phrase.words)
                          _WordChip(
                            word: pw.word,
                            translation: pw.translation,
                          ),
                      ],
                    ),
                  ),
                ],
                if (phrase.vars.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Variações',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final v in phrase.vars)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  v[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  v[1],
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                if (phrase.examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: 'Exemplos',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final example in phrase.examples)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WordChip extends StatelessWidget {
  const _WordChip({required this.word, required this.translation});

  final String word;
  final String translation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1130),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6117F4).withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            word,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            translation,
            style: const TextStyle(
              color: Color(0xFFBFA7FF),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

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
