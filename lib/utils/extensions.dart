import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:langi/providers/prefs.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  NavigatorState get navigator => Navigator.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  ScaffoldState get scaffold => Scaffold.of(this);

  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  FlutterView get view => View.of(this);

  Prefs get prefs => Prefs.of(this);

  Prefs get prefsSingle => Prefs.of(this, listen: false);
}

extension NavigatorStateExtensions on NavigatorState {
  Future pushWidget(WidgetBuilder widget) =>
      push(MaterialPageRoute(builder: widget));
}

extension FutureExtensions<T> on Future<T> {
  Future<T> atLeast(Duration duration) =>
      Future.wait([Future.delayed(duration), this]).then((value) => value.last);
}
