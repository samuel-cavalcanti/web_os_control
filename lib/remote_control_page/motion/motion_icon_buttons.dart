import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildHomeButton(void Function() onPressed) =>
    _builderIconButton(Icons.home, onPressed);

Widget buildBackButton(void Function() onPressed) =>
    _builderIconButton(FontAwesomeIcons.rotateLeft, onPressed);

Widget buildSettingsButton(void Function() onPressed) =>
    _builderIconButton(Icons.settings, onPressed);

Widget buildGuideButton(void Function() onPressed) =>
    _builderIconButton(Icons.list, onPressed);

Widget _builderIconButton(IconData iconData, void Function() onPressed) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        size: 29,
      ),
    );

Widget _builderIconButtonWithContext(
        IconData iconData, void Function() onPressed, BuildContext context) =>
    IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData,
        color: Theme.of(context).colorScheme.surface,
        size: 30,
      ),
    );

Widget buildEnter(BuildContext context, void Function() onPressed) =>
    _builderIconButtonWithContext(Icons.mode_standby, onPressed, context);

Widget buildMoveUp(BuildContext context, void Function() onPressed) =>
    _builderIconButtonWithContext(Icons.arrow_drop_up, onPressed, context);

Widget buildMoveDown(BuildContext context, void Function() onPressed) =>
    _builderIconButtonWithContext(Icons.arrow_drop_down, onPressed, context);

Widget buildMoveLeft(BuildContext context, void Function() onPressed) =>
    _builderIconButtonWithContext(Icons.arrow_left, onPressed, context);

Widget buildMoveRight(BuildContext context, void Function() onPressed) =>
    _builderIconButtonWithContext(Icons.arrow_right, onPressed, context);
