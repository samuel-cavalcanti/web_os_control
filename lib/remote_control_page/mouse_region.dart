import 'package:flutter/material.dart';

Widget mouseRegion(BuildContext context) {
  final secondaryColor = Theme.of(context).colorScheme.secondary;

  return Row(
    children: [
      Expanded(
        flex: 15,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8))),
            ),
            const Icon(
              Icons.near_me,
            )
          ],
        ),
      ),
      const Spacer(),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      )),
    ],
  );
}
