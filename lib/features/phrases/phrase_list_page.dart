import 'package:flutter/material.dart';

import 'phrase.dart';
import 'phrase_detail_page.dart';
import 'phrase_repository.dart';
import 'phrase_speech_service.dart';

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
  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.repository.orderedCategories.first.id;
  }

  bool get _isSearching => _query.isNotEmpty;

  List<Phrase> get _displayedPhrases {
    if (_isSearching) return widget.repository.search(_query);
    return widget.repository.byCategory(_selectedCategoryId);
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.repository.orderedCategories;

    return Scaffold(
      backgroundColor: const Color(0xFF101010),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        foregroundColor: Colors.white,
        title: const Text('Frases do dia a dia'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: TextField(
                    onChanged: (value) => setState(() => _query = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'pesquisar em português, inglês ou fonética...',
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
                  child: CustomScrollView(
                    slivers: [
                      if (!_isSearching)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final cat in categories)
                                  _CategoryChip(
                                    label: cat.label,
                                    isSelected: cat.id == _selectedCategoryId,
                                    isAdvanced: cat.isAdvanced,
                                    onTap: () => setState(
                                      () => _selectedCategoryId = cat.id,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _PhraseTile(
                                phrase: _displayedPhrases[index],
                              ),
                            ),
                            childCount: _displayedPhrases.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.isAdvanced,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isAdvanced;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isAdvanced ? const Color(0xFF7B2FBE) : const Color(0xFF6117F4);
    final borderColor = isAdvanced ? const Color(0xFF9B59FF) : const Color(0xFF6117F4);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? activeColor
                : isAdvanced
                    ? const Color(0xFF9B59FF).withOpacity(0.5)
                    : const Color(0xFF3A3A3A),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isAdvanced
                    ? borderColor
                    : Colors.white70,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PhraseTile extends StatefulWidget {
  const _PhraseTile({required this.phrase});

  final Phrase phrase;

  @override
  State<_PhraseTile> createState() => _PhraseTileState();
}

class _PhraseTileState extends State<_PhraseTile> {
  final _speech = PhraseSpeechService();
  bool _playing = false;

  Future<void> _togglePlay() async {
    if (_playing) return;
    setState(() => _playing = true);
    try {
      await _speech.speak(widget.phrase.text);
    } finally {
      if (mounted) setState(() => _playing = false);
    }
  }

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
              builder: (_) => PhraseDetailPage(phrase: widget.phrase),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.phrase.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.phrase.meaningPtBr,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: _playing ? null : _togglePlay,
                icon: _playing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFBFA7FF),
                        ),
                      )
                    : const Icon(Icons.volume_up_rounded),
                color: const Color(0xFFBFA7FF),
                disabledColor: const Color(0xFFBFA7FF),
                tooltip: 'ouvir em inglês',
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
