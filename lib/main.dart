import 'package:flutter/material.dart';
import 'features/phrases/phrase_list_page.dart';
import 'features/voice_conversation/voice_conversation_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6117F4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: _HomeNavigator(),
      ),
    );
  }
}

class _HomeNavigator extends StatelessWidget {
  const _HomeNavigator();

  @override
  Widget build(BuildContext context) {
    return HomePage(
      onTalkToAiPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const VoiceConversationPage(),
          ),
        );
      },
      onLearnPhrasesPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const PhraseListPage(),
          ),
        );
      },
    );
  }
}