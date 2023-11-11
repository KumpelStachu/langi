import 'package:flutter/material.dart';
import 'package:langi/models/langi.dart';
import 'package:langi/utils/extensions.dart';
import 'package:langi/widgets/card_wrapper.dart';
import 'package:langi/widgets/spoiler.dart';

class LangiCard extends StatelessWidget {
  const LangiCard({super.key, required this.langi, required this.onDelete});

  final Langi langi;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      langi.question,
                      style: context.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Divider(height: 32, thickness: 2),
                IconButton.filledTonal(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Spoiler(
                    child: SingleChildScrollView(
                      child: Text(
                        langi.answer,
                        style: context.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
