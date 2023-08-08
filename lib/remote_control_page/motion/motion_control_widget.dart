import 'package:flutter/material.dart';

import 'motion_icon_buttons.dart' as motion_icon_buttons;

enum ArrowKey { up, down, left, right }

enum SpecialKey { home, back, enter, guide, settings }

class ArrowMotion extends StatelessWidget {
  const ArrowMotion(
      {super.key,
      required this.onArrowPressed,
      required this.onSpecialKeyPressed});
  final void Function(ArrowKey) onArrowPressed;
  final void Function(SpecialKey) onSpecialKeyPressed;
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    motion_icon_buttons.buildMoveUp(
                        context, () => onArrowPressed(ArrowKey.up)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        motion_icon_buttons.buildMoveLeft(
                            context, () => onArrowPressed(ArrowKey.left)),
                        motion_icon_buttons.buildEnter(context,
                            () => onSpecialKeyPressed(SpecialKey.enter)),
                        motion_icon_buttons.buildMoveRight(
                            context, () => onArrowPressed(ArrowKey.right)),
                      ],
                    ),
                    motion_icon_buttons.buildMoveDown(
                        context, () => onArrowPressed(ArrowKey.down)),
                  ])),
        ),
      );
}

class MotionControlButtons extends StatelessWidget {
  const MotionControlButtons(
      {super.key,
      required this.onArrowPressed,
      required this.onSpecialKeyPressed});

  final void Function(ArrowKey) onArrowPressed;
  final void Function(SpecialKey) onSpecialKeyPressed;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                motion_icon_buttons.buildHomeButton(
                  () => onSpecialKeyPressed(SpecialKey.home),
                ),
                motion_icon_buttons.buildBackButton(
                  () => onSpecialKeyPressed(SpecialKey.back),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: ArrowMotion(
                onArrowPressed: onArrowPressed,
                onSpecialKeyPressed: onSpecialKeyPressed,
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                motion_icon_buttons.buildSettingsButton(
                  () => onSpecialKeyPressed(SpecialKey.settings),
                ),
                motion_icon_buttons.buildGuideButton(
                  () => onSpecialKeyPressed(SpecialKey.guide),
                )
              ],
            ),
          )
        ],
      );
}
