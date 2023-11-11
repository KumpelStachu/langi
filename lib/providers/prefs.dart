import 'package:flutter/material.dart';
import 'package:langi/models/question_level.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs extends ChangeNotifier {
  static late final SharedPreferences _prefs;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Prefs of(BuildContext context, {bool listen = true}) =>
      Provider.of<Prefs>(context, listen: listen);

  String get topic => _prefs.getString('topic') ?? 'anything';
  set topic(String topic) {
    _prefs.setString('topic', topic);
    notifyListeners();
  }

  QuestionLevel get level =>
      QuestionLevel.values.byName(_prefs.getString('level') ?? 'B1');
  set level(QuestionLevel level) {
    _prefs.setString('level', level.name);
    notifyListeners();
  }

  Color? get color =>
      _prefs.containsKey('color') ? Color(_prefs.getInt('color')!) : null;
  set color(Color? color) {
    if (color == null) {
      _prefs.remove('color');
    } else {
      _prefs.setInt('color', color.value);
    }

    notifyListeners();
  }

  int get usedTokens => _prefs.getInt('usedTokens') ?? 0;
  set usedTokens(int usedTokens) {
    _prefs.setInt('usedTokens', usedTokens);
    notifyListeners();
  }
}
