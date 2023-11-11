import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:langi/models/langi.dart';
import 'package:langi/services/langi.dart';
import 'package:langi/utils/extensions.dart';
import 'package:langi/widgets/card_wrapper.dart';

class LangiLoader extends StatefulWidget {
  const LangiLoader(this.onLoaded, {super.key});

  final Function(Langi) onLoaded;

  @override
  State<LangiLoader> createState() => _LangiLoaderState();
}

class _LangiLoaderState extends State<LangiLoader> {
  late Future _future;
  dynamic error;

  @override
  void initState() {
    super.initState();
    _future = _loadLangi();
  }

  @override
  void dispose() {
    _future.ignore();
    super.dispose();
  }

  Future<void> _loadLangi() async {
    final prefs = context.prefsSingle;

    setState(() => error = null);

    try {
      final langi = await LangiService.generate(
        topic: prefs.topic,
        level: prefs.level,
      );

      widget.onLoaded(langi);
    } catch (e) {
      if (!mounted) return;
      if (e is FirebaseFunctionsException) {
        setState(() => error = e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Builder(
        builder: (context) {
          if (error != null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 32),
                const Gap(8),
                Text(
                  'Something went wrong 😢\n$error',
                  style: context.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                // const Gap(8),
                TextButton(
                  onPressed: () => _future = _loadLangi(),
                  child: const Text('Retry'),
                )
              ],
            );
          }

          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Gap(12),
              Text('Thinking 🤔'),
            ],
          );
        },
      ),
    );
  }
}
