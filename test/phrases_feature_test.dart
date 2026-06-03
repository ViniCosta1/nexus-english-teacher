import 'package:beach_talk/features/phrases/phrase_detail_page.dart';
import 'package:beach_talk/features/phrases/phrase_list_page.dart';
import 'package:beach_talk/features/phrases/phrase_repository.dart';
import 'package:beach_talk/features/phrases/phrase_speech_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local phrase repository exposes daily English expressions', () {
    final repository = PhraseRepository();

    expect(repository.all, hasLength(greaterThanOrEqualTo(45)));
    expect(
      repository.search('morning').map((phrase) => phrase.text),
      contains('Good morning!'),
    );
    expect(
      repository.search('makes sense').map((phrase) => phrase.text),
      contains('That makes sense.'),
    );
    expect(
      repository.search('down').map((phrase) => phrase.text),
      contains("I'm down."),
    );
    expect(repository.categories, contains('daily'));
  });

  testWidgets('phrase list searches and opens a phrase detail', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PhraseListPage(),
      ),
    );

    expect(find.text('Frases do dia a dia'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'morning');
    await tester.pumpAndSettle();

    expect(find.text('Good morning!'), findsOneWidget);
    await tester.tap(find.text('Good morning!'));
    await tester.pumpAndSettle();

    expect(find.byType(PhraseDetailPage), findsOneWidget);
    expect(find.text('Bom dia!'), findsOneWidget);
    expect(find.textContaining('Pronuncia'), findsOneWidget);
    expect(find.text('ouvir frase'), findsOneWidget);
  });

  testWidgets('phrase detail plays AI generated pronunciation audio', (
    tester,
  ) async {
    final phrase = PhraseRepository().search('makes sense').first;
    final speechService = _FakePhraseSpeechService();

    await tester.pumpWidget(
      MaterialApp(
        home: PhraseDetailPage(
          phrase: phrase,
          speechService: speechService,
        ),
      ),
    );

    await tester.tap(find.text('ouvir frase'));
    await tester.pumpAndSettle();

    expect(speechService.spokenText, 'That makes sense.');
  });
}

class _FakePhraseSpeechService extends PhraseSpeechService {
  _FakePhraseSpeechService() : super(engine: _NoopTtsEngine());

  String? spokenText;

  @override
  Future<void> speak(String text) async {
    spokenText = text;
  }
}

class _NoopTtsEngine implements PhraseTtsEngine {
  @override
  Future<void> speak(String text) async {}

  @override
  Future<void> stop() async {}
}
