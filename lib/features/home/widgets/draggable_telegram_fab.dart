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
  static const double _bottomNavHeight = 0;
  Offset? _position;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final buttonSize = TelegramFloatingActionButton.diameter;
        final maxX = (constraints.maxWidth - buttonSize).clamp(
          0.0,
          double.infinity,
        );
        final rawMaxY = (constraints.maxHeight - buttonSize).clamp(
          0.0,
          double.infinity,
        );
        final bottomBlockedArea =
            _bottomNavHeight + mediaQuery.padding.bottom + _edgeMargin;
        final maxY = (rawMaxY - bottomBlockedArea).clamp(0.0, rawMaxY);

        final defaultX = (maxX - _edgeMargin).clamp(0.0, maxX);
        final defaultY = (maxY - (_edgeMargin + 80)).clamp(0.0, maxY);
        final rawCurrent = _position ?? Offset(defaultX, defaultY);
        final current = Offset(
          rawCurrent.dx.clamp(0.0, maxX),
          rawCurrent.dy.clamp(0.0, maxY),
        );
        final midX = maxX / 2;

        return Stack(
          children: [
            AnimatedPositioned(
              duration: _isDragging
                  ? Duration.zero
                  : const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              left: current.dx.clamp(0.0, maxX),
              top: current.dy.clamp(0.0, maxY),
              child: GestureDetector(
                onPanStart: (_) {
                  if (!_isDragging) {
                    setState(() => _isDragging = true);
                  }
                },
                onPanUpdate: (details) {
                  final next = Offset(
                    (current.dx + details.delta.dx).clamp(0.0, maxX),
                    (current.dy + details.delta.dy).clamp(0.0, maxY),
                  );
                  setState(() => _position = next);
                },
                onPanEnd: (_) {
                  final snappedX = current.dx <= midX ? 0.0 : maxX;
                  setState(() {
                    _isDragging = false;
                    _position = Offset(snappedX, current.dy);
                  });
                },
                onPanCancel: () {
                  if (_isDragging) {
                    setState(() => _isDragging = false);
                  }
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
