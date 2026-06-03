# Orb Home Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a reusable purple orb component and redesign the home page to match the provided wireframe.

**Architecture:** The orb will live in its own widget file and be drawn with `CustomPainter`, so it can be reused without image assets. `HomePage` will compose the greeting, orb, prompt text, and outlined buttons. The existing `MaterialApp` remains the entry point.

**Tech Stack:** Flutter, Dart, `CustomPainter`, `WidgetTester`.

---

## File Structure

- Create: `lib/components/orb.dart`
  - Reusable `Orb` widget.
  - Accepts `size` and `color`.
  - Draws translucent layered circles and a subtle ring using `CustomPainter`.
- Modify: `lib/home_page.dart`
  - Imports `Orb`.
  - Applies dark background.
  - Builds the wireframe layout with greeting, orb, prompt, and two outlined buttons.
- Modify: `lib/main.dart`
  - Removes the default visible `AppBar` so the home screen matches the full-page wireframe.
- Modify: `test/widget_test.dart`
  - Verifies the main texts and buttons render.

## Task 1: Reusable Orb Widget

**Files:**
- Create: `lib/components/orb.dart`

- [ ] **Step 1: Create the reusable widget**

```dart
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Orb extends StatelessWidget {
  const Orb({
    super.key,
    this.size = 120,
    this.color = const Color(0xFF6117F4),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _OrbPainter(color),
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  const _OrbPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shortestSide = min(size.width, size.height);
    final radius = shortestSide * 0.34;

    final glowPaint = Paint()
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortestSide * 0.08);

    for (final layer in _layers(shortestSide)) {
      glowPaint.color = color.withValues(alpha: layer.opacity);
      canvas.drawOval(
        Rect.fromCenter(
          center: center + layer.offset,
          width: radius * layer.width,
          height: radius * layer.height,
        ),
        glowPaint,
      );
    }

    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.92),
          color.withValues(alpha: 0.5),
          color.withValues(alpha: 0.16),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, corePaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = shortestSide * 0.035
      ..color = color.withValues(alpha: 0.22)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortestSide * 0.025);

    canvas.drawCircle(center, radius * 1.04, ringPaint);
  }

  List<_OrbLayer> _layers(double size) {
    return [
      _OrbLayer(Offset(-size * 0.08, -size * 0.07), 2.05, 1.5, 0.18),
      _OrbLayer(Offset(size * 0.1, -size * 0.02), 1.75, 1.85, 0.16),
      _OrbLayer(Offset(-size * 0.02, size * 0.1), 1.45, 1.95, 0.12),
      _OrbLayer(Offset(size * 0.04, size * 0.02), 1.55, 1.5, 0.2),
    ];
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _OrbLayer {
  const _OrbLayer(this.offset, this.width, this.height, this.opacity);

  final Offset offset;
  final double width;
  final double height;
  final double opacity;
}
```

- [ ] **Step 2: Run analyzer**

Run: `flutter analyze`

Expected: no analyzer errors.

## Task 2: Wireframe Home Page

**Files:**
- Modify: `lib/home_page.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: Update `HomePage` layout**

Replace the current amber `Container` with a full-screen dark layout:

```dart
import 'package:flutter/material.dart';

import 'components/orb.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF101010),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Olá, Fernanda. I'm Teacher da Fer",
                  style: TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Orb(size: 142),
              const SizedBox(height: 42),
              const Text(
                'Sobre o que\npodemos conversar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFF2F2F2),
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 36),
              _HomeActionButton(
                label: 'falar com ia',
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              _HomeActionButton(
                label: 'aprender frases',
                onPressed: () {},
              ),
            ],
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
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF2F2F2),
          side: const BorderSide(color: Color(0xFFF2F2F2), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
```

- [ ] **Step 2: Remove the default app bar**

Update `lib/main.dart` so the scaffold only renders the body:

```dart
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}
```

- [ ] **Step 3: Run analyzer**

Run: `flutter analyze`

Expected: no analyzer errors.

## Task 3: Widget Test

**Files:**
- Modify: `test/widget_test.dart`

- [ ] **Step 1: Replace the default counter test**

```dart
import 'package:beach_talk/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the home page actions', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Olá, Fernanda'), findsOneWidget);
    expect(find.text('Sobre o que\npodemos conversar?'), findsOneWidget);
    expect(find.text('falar com ia'), findsOneWidget);
    expect(find.text('aprender frases'), findsOneWidget);
  });
}
```

- [ ] **Step 2: Run tests**

Run: `flutter test`

Expected: all widget tests pass.

## Self-Review

- Spec coverage: covers reusable orb, purple `#6117f4` tone, and home page wireframe.
- Placeholder scan: no TODO/TBD placeholders remain.
- Type consistency: `Orb`, `HomePage`, and `MyApp` names match the current project.
