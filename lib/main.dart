import 'dart:async';
import 'dart:io';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:langi/firebase_options.dart';
import 'package:langi/pages/home_page.dart';
import 'package:langi/providers/prefs.dart';
import 'package:langi/utils/extensions.dart';
import 'package:langi/utils/lets_encrypt.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await patchLetsEncrypt();
  await Prefs.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
  );
  await FirebaseRemoteConfig.instance.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval:
        kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 1),
  ));
  await FirebaseRemoteConfig.instance.setDefaults({
    'levelSelector': true,
    'themeSelector': false,
    'rewardTier2': 200,
    'rewardTier3': 300,
  });
  await FirebaseRemoteConfig.instance.fetchAndActivate();

  FirebaseUIAuth.configureProviders([
    GoogleProvider(
      clientId:
          '1087936669343-7k1o4bpg5oq1f5tdbmelvkkk8gec4259.apps.googleusercontent.com',
    ),
  ]);

  if (Platform.isAndroid || Platform.isIOS) {
    await MobileAds.instance.initialize();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => Prefs(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightScheme, darkScheme) {
      final color = context.prefs.color;

      return MaterialApp(
        title: 'Langi',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: color == null && lightScheme != null
              ? lightScheme
              : ColorScheme.fromSeed(seedColor: color ?? Colors.deepPurple),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: color == null && darkScheme != null
              ? darkScheme
              : ColorScheme.fromSeed(
                  seedColor: color ?? Colors.deepPurple,
                  brightness: Brightness.dark,
                ),
          brightness: Brightness.dark,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasData) {
              return const HomePage();
            }

            return const SignInScreen();
          },
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQueryData.fromView(context.view)
              .copyWith(textScaleFactor: 1),
          child: AnnotatedRegion(
            value: SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: (context.colorScheme).background,
            ),
            child: child ?? const SizedBox(),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
