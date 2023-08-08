import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';

class ScrollBar extends StatefulWidget {
  const ScrollBar({super.key, required this.onMoveY});
  final void Function(double dy) onMoveY;
  @override
  State<StatefulWidget> createState() => _ScrollBarState();
}

class _ScrollBarState extends State<ScrollBar> {
  final Vector3 _ballPos = Vector3(0.0, 0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onVerticalDragUpdate: (details) => setState(() =>
            _moveBall(_offsetToSpeedVector(details), context.size?.height)),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: BorderRadius.circular(8)),
          width: 20,
          height: double.infinity,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              transform: Matrix4.translation(_ballPos),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle),
            ),
          ),
        ),
      ),
    );
  }

  Vector3 _offsetToSpeedVector(DragUpdateDetails details) =>
      Vector3(details.delta.dx, details.delta.dy, 0.0);

  void _moveBall(Vector3 speed, double? sizeY) {
    if (sizeY == null) {
      return;
    }
    final maxHeight = sizeY / 2.0;

    _ballPos.add(speed);
    if (_ballPos.y > maxHeight) _ballPos.y = -maxHeight;
    if (_ballPos.y < -maxHeight) _ballPos.y = maxHeight;
    widget.onMoveY(speed.y);
  }
}
