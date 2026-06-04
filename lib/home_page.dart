import 'package:flutter/material.dart';

import 'components/orb.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    this.onTalkToAiPressed,
    this.onLearnPhrasesPressed,
  });

  final VoidCallback? onTalkToAiPressed;
  final VoidCallback? onLearnPhrasesPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Color(0xFF101010),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 32,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Olá, Fernanda. I'm Teacher da Fer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Center(child: Orb(size: 164)),
                          const SizedBox(height: 44),
                          const Text(
                            'Sobre o que\npodemos conversar?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              height: 1.15,
                            ),
                          ),
                          const Spacer(),
                          _HomeActionButton(
                            label: 'falar com ia',
                            onPressed: onTalkToAiPressed,
                          ),
                          const SizedBox(height: 14),
                          _HomeActionButton(
                            label: 'aprender frases',
                            onPressed: onLearnPhrasesPressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white70,
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: Color(0xFFE7E7E7), width: 1.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
      ),
      child: Text(label),
    );
  }
}