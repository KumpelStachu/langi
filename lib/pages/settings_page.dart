import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:langi/models/question_level.dart';
import 'package:langi/utils/extensions.dart';

const colors = {
  'Red': Colors.red,
  'Pink': Colors.pink,
  'Purple': Colors.purple,
  'Deep Purple': Colors.deepPurple,
  'Indigo': Colors.indigo,
  'Blue': Colors.blue,
  'Light Blue': Colors.lightBlue,
  'Cyan': Colors.cyan,
  'Teal': Colors.teal,
  'Green': Colors.green,
  'Light Green': Colors.lightGreen,
  'Lime': Colors.lime,
  'Yellow': Colors.yellow,
  'Amber': Colors.amber,
  'Orange': Colors.orange,
  'Deep Orange': Colors.deepOrange,
  'Brown': Colors.brown,
  'Grey': Colors.grey,
  'Blue Grey': Colors.blueGrey,
};

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController _topicController =
      TextEditingController(text: context.prefsSingle.topic);
  late var _selectedLevel = context.prefsSingle.level;
  late var _selectedColor = context.prefsSingle.color;

  @override
  Widget build(BuildContext context) {
    final config = FirebaseRemoteConfig.instance;
    final showLevel = config.getBool('levelSelector');
    final showTheme = config.getBool('themeSelector');

    print(config.getAll()['themeSelector']);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Topic',
                hintText: 'e.g. computers, defaults to "anything"',
                isDense: true,
                suffixIcon: IconButton(
                  onPressed: () => _topicController.clear(),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const Gap(8),
            if (showLevel) ...[
              const Divider(),
              Text('Select level', style: context.textTheme.titleMedium),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: [
                  for (final level in QuestionLevel.values)
                    ChoiceChip(
                      label: Text(level.name),
                      onSelected: (value) =>
                          setState(() => _selectedLevel = level),
                      selected: _selectedLevel == level,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                ],
              ),
            ],
            if (showTheme) ...[
              const Divider(),
              Text('Select theme', style: context.textTheme.titleMedium),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('System'),
                    onSelected: (value) =>
                        setState(() => _selectedColor = null),
                    selected: _selectedColor == null,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  for (final color in colors.entries)
                    Theme(
                      data: ThemeData(
                        useMaterial3: true,
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: color.value,
                          brightness: context.theme.brightness,
                        ),
                        brightness: context.theme.brightness,
                      ),
                      child: ChoiceChip(
                        label: Text(color.key),
                        onSelected: (value) =>
                            setState(() => _selectedColor = color.value),
                        selected: _selectedColor?.value == color.value.value,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                ],
              ),
            ] else
              const SizedBox(height: 150),
            const Divider(),
            Flex(
              direction: Axis.horizontal,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    context.navigator.pop();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
                const Expanded(child: SizedBox()),
                OutlinedButton(
                  onPressed: () => context.navigator.pop(),
                  child: const Text('Cancel'),
                ),
                const Gap(8),
                FilledButton(
                  onPressed: () {
                    final prefs = context.prefsSingle;

                    prefs.topic = _topicController.text.isNotEmpty
                        ? _topicController.text
                        : 'anything';
                    prefs.level = _selectedLevel;
                    prefs.color = _selectedColor;

                    context.navigator.pop();
                    context.scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Saved settings.'),
                        showCloseIcon: true,
                      ),
                    );
                  },
                  child: const Text('Save'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
