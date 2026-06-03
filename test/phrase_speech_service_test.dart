import 'package:beach_talk/features/phrases/phrase_speech_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('PhraseSpeechService speaks the trimmed phrase through the engine',
      () async {
    final engine = _RecordingTtsEngine();
    final service = PhraseSpeechService(engine: engine);

    await service.speak('  That makes sense.  ');

    expect(engine.spoken, ['That makes sense.']);
  });

  test('PhraseSpeechService ignores empty phrases', () async {
    final engine = _RecordingTtsEngine();
    final service = PhraseSpeechService(engine: engine);

    await service.speak('   ');

    expect(engine.spoken, isEmpty);
  });

  test('PhraseSpeechService wraps engine errors', () async {
    final service = PhraseSpeechService(engine: _ThrowingTtsEngine());

    expect(
      () => service.speak('hello'),
      throwsA(isA<PhraseSpeechException>()),
    );
  });
}

class _RecordingTtsEngine implements PhraseTtsEngine {
  final List<String> spoken = [];

  @override
  Future<void> speak(String text) async {
    spoken.add(text);
  }

  @override
  Future<void> stop() async {}
}

class _ThrowingTtsEngine implements PhraseTtsEngine {
  @override
  Future<void> speak(String text) async {
    throw StateError('tts unavailable');
  }

  @override
  Future<void> stop() async {}
}
