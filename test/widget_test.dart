import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:beach_talk/features/phrases/phrase_list_page.dart';
import 'package:beach_talk/features/voice_conversation/voice_conversation_page.dart';
import 'package:beach_talk/main.dart';

void main() {
  testWidgets('MyApp opens the home page without an app bar', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(AppBar), findsNothing);
    expect(find.text('Olá, Fernanda'), findsOneWidget);
    expect(find.text('Sobre o que\npodemos conversar?'), findsOneWidget);
    expect(find.text('falar com ia'), findsOneWidget);
    expect(find.text('aprender frases'), findsOneWidget);
  });

  testWidgets('home actions navigate to voice and phrase features', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('aprender frases'));
    await tester.pumpAndSettle();
    expect(find.byType(PhraseListPage), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('falar com ia'));
    await tester.pumpAndSettle();
    expect(find.byType(VoiceConversationPage), findsOneWidget);
  });
}
