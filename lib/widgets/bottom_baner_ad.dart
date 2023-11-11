import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:langi/utils/extensions.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BottomBanerAd extends StatefulWidget {
  const BottomBanerAd({super.key});

  @override
  State<BottomBanerAd> createState() => _BottomBanerAdState();
}

class _BottomBanerAdState extends State<BottomBanerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3424996550663655/5670803773';

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid || Platform.isIOS) loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Ad loaded');
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    // return SizedBox();
    if (!_isLoaded) {
      return SizedBox(
        height: 50,
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => launchUrlString(
              'https://langi.kums.dev/donate',
              mode: LaunchMode.externalApplication,
            ),
            child: Center(
              child: Text(
                'Click here to support Langi! 🥺',
                style: context.textTheme.titleMedium,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
