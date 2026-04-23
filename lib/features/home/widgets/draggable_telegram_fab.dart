import 'package:flutter/material.dart';

import 'telegram_floating_action_button.dart';

/// Draggable wrapper for the Telegram floating action button.
///
/// Keeps the existing Telegram button tap behavior and lets users
/// reposition it within the visible home content area.
class DraggableTelegramFab extends StatefulWidget {
  const DraggableTelegramFab({super.key});

  @override
  State<DraggableTelegramFab> createState() => _DraggableTelegramFabState();
}

class _DraggableTelegramFabState extends State<DraggableTelegramFab> {
  static const double _edgeMargin = 12;
  Offset? _position;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final buttonSize = TelegramFloatingActionButton.diameter;
        final maxX = (constraints.maxWidth - buttonSize).clamp(0.0, double.infinity);
        final maxY = (constraints.maxHeight - buttonSize).clamp(0.0, double.infinity);

        final defaultX = (maxX - _edgeMargin).clamp(0.0, maxX);
        final defaultY = (maxY - (_edgeMargin + 80)).clamp(0.0, maxY);
        final current = _position ?? Offset(defaultX, defaultY);

        return Stack(
          children: [
            Positioned(
              left: current.dx.clamp(0.0, maxX),
              top: current.dy.clamp(0.0, maxY),
              child: GestureDetector(
                onPanUpdate: (details) {
                  final next = Offset(
                    (current.dx + details.delta.dx).clamp(0.0, maxX),
                    (current.dy + details.delta.dy).clamp(0.0, maxY),
                  );
                  setState(() => _position = next);
                },
                child: const TelegramFloatingActionButton(),
              ),
            ),
          ],
        );
      },
    );
  }
}
