import 'package:flutter_tts/flutter_tts.dart';

/// Reads a phrase out loud. Backed by the device's native text-to-speech
/// engine (the same one used by apps like Google Translate), so pronunciation
/// works offline and without calling the paid OpenAI speech endpoint.
abstract class PhraseTtsEngine {
  Future<void> speak(String text);

  Future<void> stop();
}

class FlutterTtsPhraseEngine implements PhraseTtsEngine {
  FlutterTtsPhraseEngine({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;
  bool _configured = false;

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _tts.setLanguage('en-US');
    // On web the browser may not honor setLanguage unless a matching voice is
    // explicitly selected — pick the first available English voice.
    try {
      final voices = await _tts.getVoices as List?;
      if (voices != null) {
        final enVoice = voices.cast<Map>().firstWhere(
          (v) => (v['locale'] as String? ?? v['lang'] as String? ?? '')
              .toLowerCase()
              .startsWith('en'),
          orElse: () => <String, String>{},
        );
        if (enVoice.isNotEmpty) {
          await _tts.setVoice({
            'name': enVoice['name'] as String,
            'locale': (enVoice['locale'] ?? enVoice['lang']) as String,
          });
        }
      }
    } catch (_) {
      // voice selection is best-effort; proceed with language-only setting
    }
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  @override
  Future<void> speak(String text) async {
    await _ensureConfigured();
    await _tts.stop();
    // Re-apply language on every call — some web browsers reset it between utterances.
    await _tts.setLanguage('en-US');
    await _tts.speak(text);
  }

  @override
  Future<void> stop() => _tts.stop();
}

class PhraseSpeechService {
  PhraseSpeechService({PhraseTtsEngine? engine})
      : _engine = engine ?? FlutterTtsPhraseEngine();

  final PhraseTtsEngine _engine;

  Future<void> speak(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    try {
      await _engine.speak(trimmed);
    } catch (error) {
      throw PhraseSpeechException(
        'Não foi possível reproduzir a pronúncia: $error',
      );
    }
  }
}

class PhraseSpeechException implements Exception {
  const PhraseSpeechException(this.message);

  final String message;

  @override
  String toString() => message;
}
