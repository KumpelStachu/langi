import 'package:flutter/material.dart';

class Spoiler extends StatefulWidget {
  const Spoiler({super.key, required this.child});

  final Widget child;

  @override
  State<Spoiler> createState() => _SpoilerState();
}

class _SpoilerState extends State<Spoiler> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedOpacity(
          opacity: _isExpanded ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: widget.child,
        ),
        if (!_isExpanded)
          OutlinedButton.icon(
            onPressed: () => setState(() => _isExpanded = true),
            icon: const Icon(Icons.remove_red_eye),
            label: const Text('Tap to reveal answer'),
          ),
      ],
    );
  }
}
