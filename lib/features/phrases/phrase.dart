class Phrase {
  const Phrase({
    required this.text,
    required this.meaningPtBr,
    required this.pronunciationHint,
    required this.examples,
    required this.category,
  });

  final String text;
  final String meaningPtBr;
  final String pronunciationHint;
  final List<String> examples;
  final String category;
}
