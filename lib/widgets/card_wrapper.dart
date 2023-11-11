import 'package:flutter/material.dart';

class CardWrapper extends StatelessWidget {
  const CardWrapper({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
      child: child,
    );
  }
}
