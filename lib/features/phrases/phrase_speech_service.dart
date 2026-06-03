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
    if (_configured) {
      return;
    }
    await _tts.setLanguage('en-US');
    // Slightly slower than default so learners can follow the pronunciation.
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
    _configured = true;
  }

  @override
  Future<void> speak(String text) async {
    await _ensureConfigured();
    await _tts.stop();
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
