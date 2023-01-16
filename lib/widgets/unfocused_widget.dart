import 'package:flutter/material.dart';

class UnFocusedWidget extends StatelessWidget {
  final Widget child;

  const UnFocusedWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (primaryFocus != null) {
          primaryFocus!.unfocus();
        }
      },
      child: child,
    );
  }
}
