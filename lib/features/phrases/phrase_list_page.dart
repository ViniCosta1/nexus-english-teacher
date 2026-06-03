import 'package:flutter/material.dart';

import 'phrase.dart';
import 'phrase_detail_page.dart';
import 'phrase_repository.dart';

class PhraseListPage extends StatefulWidget {
  const PhraseListPage({
    super.key,
    PhraseRepository? repository,
  }) : repository = repository ?? const _DefaultPhraseRepository();

  final PhraseRepository repository;

  @override
  State<PhraseListPage> createState() => _PhraseListPageState();
}

class _PhraseListPageState extends State<PhraseListPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final phrases = widget.repository.search(_query);

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        title: const Text('Frases do dia a dia'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: TextField(
                onChanged: (value) => setState(() => _query = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'pesquisar...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF181818),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: const BorderSide(color: Color(0xFF6117F4)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: phrases.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _PhraseTile(phrase: phrases[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhraseTile extends StatelessWidget {
  const _PhraseTile({required this.phrase});

  final Phrase phrase;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF181818),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PhraseDetailPage(phrase: phrase),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phrase.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                phrase.meaningPtBr,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DefaultPhraseRepository extends PhraseRepository {
  const _DefaultPhraseRepository();
}
