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
              child: Column(children: [
                Expanded(
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 4,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.elliptical(300, 150),
                                topLeft: Radius.elliptical(300, 150)),
                            //color: Colors.red,
                          ),
                          child: motion_icon_buttons.buildMoveUp(
                              context, () => onArrowPressed(ArrowKey.up)),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            //color: Colors.yellow,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.elliptical(150, 400),
                              bottomLeft: Radius.elliptical(150, 400),
                            ),
                          ),
                          child: motion_icon_buttons.buildMoveLeft(
                              context, () => onArrowPressed(ArrowKey.left)),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(), shape: BoxShape.circle),
                          child: motion_icon_buttons.buildEnter(context,
                              () => onSpecialKeyPressed(SpecialKey.enter)),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              //color: Colors.pink,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.elliptical(150, 400),
                                  bottomRight: Radius.elliptical(150, 400)),
                              shape: BoxShape.rectangle),
                          child: motion_icon_buttons.buildMoveRight(
                              context, () => onArrowPressed(ArrowKey.right)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(300, 150),
                              bottomRight: Radius.elliptical(300, 150),
                            ),
                            //color: Colors.green,
                          ),
                          child: motion_icon_buttons.buildMoveDown(
                              context, () => onArrowPressed(ArrowKey.down)),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
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
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
        child: Row(
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
        ),
      );
}
