import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'motion_controller.dart';

const void Function(MotionKey) _onPressed = pressedMotionKey;
const _moveIconSize = 30.0;

Widget buildHomeButton() => IconButton(
      onPressed: () => _onPressed(MotionKey.home),
      icon: const Icon(
        Icons.home,
        size: 29,
      ),
    );
Widget buildBackButton() => IconButton(
      onPressed: () => _onPressed(MotionKey.back),
      icon: const FaIcon(
        FontAwesomeIcons.rotateLeft,
        size: 29,
      ),
    );

Widget _builderIconButton(
        IconData iconData, MotionKey key, BuildContext context) =>
    IconButton(
      onPressed: () => _onPressed(key),
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.surface,
        size: _moveIconSize,
      ),
    );

Widget buildEnter(BuildContext context) =>
    _builderIconButton(Icons.mode_standby, MotionKey.enter, context);

Widget buildMoveUp(BuildContext context) =>
    _builderIconButton(Icons.arrow_drop_up, MotionKey.up, context);

Widget buildMoveDown(BuildContext context) =>
    _builderIconButton(Icons.arrow_drop_down, MotionKey.down, context);

Widget buildMoveLeft(BuildContext context) =>
    _builderIconButton(Icons.arrow_left, MotionKey.left, context);

Widget buildMoveRight(BuildContext context) =>
    _builderIconButton(Icons.arrow_right, MotionKey.right, context);
