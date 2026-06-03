import 'package:beach_talk/components/orb.dart';
import 'package:beach_talk/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('HomePage matches the approved landing layout', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.text('Olá, Fernanda'), findsOneWidget);
    expect(find.byType(Orb), findsOneWidget);
    expect(find.text('Sobre o que\npodemos conversar?'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'falar com ia'), findsOneWidget);
    expect(
      find.widgetWithText(OutlinedButton, 'aprender frases'),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is ColoredBox && widget.color == const Color(0xFF101010),
      ),
      findsOneWidget,
    );
  });

  testWidgets('HomePage disables actions until callbacks are provided', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    final talkButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'falar com ia'),
    );
    final phrasesButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'aprender frases'),
    );

    expect(talkButton.onPressed, isNull);
    expect(phrasesButton.onPressed, isNull);
  });

  testWidgets('HomePage invokes provided action callbacks', (tester) async {
    var talkTapCount = 0;
    var phrasesTapCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(
          onTalkToAiPressed: () => talkTapCount++,
          onLearnPhrasesPressed: () => phrasesTapCount++,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(OutlinedButton, 'falar com ia'));
    await tester.tap(find.widgetWithText(OutlinedButton, 'aprender frases'));

    expect(talkTapCount, 1);
    expect(phrasesTapCount, 1);
  });

  testWidgets('HomePage remains scrollable on short screens', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 420));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(320, 420),
            textScaler: TextScaler.linear(1.8),
          ),
          child: HomePage(),
        ),
      ),
    );

    final learnPhrasesButton = find.widgetWithText(
      OutlinedButton,
      'aprender frases',
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(learnPhrasesButton, findsOneWidget);
    expect(learnPhrasesButton.hitTestable(), findsNothing);

    await tester.ensureVisible(learnPhrasesButton);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(learnPhrasesButton.hitTestable(), findsOneWidget);
  });
}
