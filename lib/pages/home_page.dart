import 'package:flutter/material.dart';
import 'package:langi/models/langi.dart';
import 'package:langi/pages/settings_page.dart';
import 'package:langi/widgets/bottom_baner_ad.dart';
import 'package:langi/widgets/langi_card.dart';
import 'package:langi/widgets/langi_loader.dart';
import 'package:langi/widgets/tokens_button.dart';
import 'package:langi/widgets/welcome_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _langis = <Langi>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TokensButton(),
        actions: [
          TextButton(
            onPressed: () => setState(() => _langis.clear()),
            child: const Text('Clear'),
          ),
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (_) => const SettingsPage(),
            ),
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () => showLicensePage(context: context),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const WelcomeCard();
          }

          if (index > _langis.length) {
            return LangiLoader((langi) => setState(() => _langis.add(langi)));
          }

          return LangiCard(
            langi: _langis[index - 1],
            onDelete: () => setState(() => _langis.removeAt(index - 1)),
          );
        },
        itemCount: _langis.length + 2,
      ),
      bottomNavigationBar: const BottomBanerAd(),
    );
  }
}
