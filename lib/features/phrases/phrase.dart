class PhraseWord {
  const PhraseWord({required this.word, required this.translation});
  final String word;
  final String translation;
}

class PhraseCategory {
  const PhraseCategory({
    required this.id,
    required this.label,
    this.isAdvanced = false,
  });
  final String id;
  final String label;
  final bool isAdvanced;
}

class Phrase {
  const Phrase({
    required this.text,
    required this.meaningPtBr,
    required this.pronunciationHint,
    this.examples = const [],
    required this.category,
    this.words = const [],
    this.vars = const [],
  });

  final String text;
  final String meaningPtBr;
  final String pronunciationHint;
  final List<String> examples;
  final String category;
  final List<PhraseWord> words;
  final List<List<String>> vars;
}
