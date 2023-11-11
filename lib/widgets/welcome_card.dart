import 'package:flutter/material.dart';
import 'package:langi/utils/extensions.dart';
import 'package:langi/widgets/card_wrapper.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(child: SizedBox()),
            Text(
              'Welcome to Langi!',
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall,
            ),
            Text(
              'Your AI English teacher',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            const Expanded(child: SizedBox()),
            const Text(
              'Swipe to start learning!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
