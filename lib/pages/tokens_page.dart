import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:langi/utils/extensions.dart';

const maxFailedLoadAttempts = 5;

const _interstitialAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/8691691433'
    : 'ca-app-pub-3424996550663655/6995848953';

const _rewardedAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/5224354917'
    : 'ca-app-pub-3424996550663655/6700852403';

const _rewardedInterstitialAdUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/5354046379'
    : 'ca-app-pub-3424996550663655/1743522274';

class TokensPage extends StatefulWidget {
  const TokensPage({super.key});

  @override
  State<TokensPage> createState() => _TokensPageState();
}

class _TokensPageState extends State<TokensPage> {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;

  int _interstitialLoadAttempts = 0;
  int _rewardedLoadAttempts = 0;
  int _rewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    _loadRewardedAd();
    _loadRewardedInterstitialAd();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _interstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          });
        },
        onAdFailedToLoad: (error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _loadInterstitialAd();
          }
        },
      ),
    );
  }

  _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _rewardedLoadAttempts = 0;
            _rewardedAd!.setImmersiveMode(true);
            _rewardedAd!.setServerSideOptions(
              ServerSideVerificationOptions(
                userId: FirebaseAuth.instance.currentUser?.uid,
              ),
            );
          });
        },
        onAdFailedToLoad: (error) {
          _rewardedLoadAttempts += 1;
          _rewardedAd = null;
          if (_rewardedLoadAttempts <= maxFailedLoadAttempts) {
            _loadRewardedAd();
          }
        },
      ),
    );
  }

  _loadRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
      adUnitId: _rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedInterstitialAd = ad;
            _rewardedInterstitialLoadAttempts = 0;
            _rewardedInterstitialAd!.setImmersiveMode(true);
            _rewardedInterstitialAd!.setServerSideOptions(
              ServerSideVerificationOptions(
                userId: FirebaseAuth.instance.currentUser?.uid,
              ),
            );
          });
        },
        onAdFailedToLoad: (error) {
          _rewardedInterstitialLoadAttempts += 1;
          _rewardedInterstitialAd = null;
          if (_rewardedInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            _loadRewardedInterstitialAd();
          }
        },
      ),
    );
  }

  _showInterstitialAd() {
    _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        context.navigator.pop();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadInterstitialAd();
      },
    );
    _interstitialAd?.show();
    _interstitialAd = null;
  }

  _showRewardedAd() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        context.navigator.pop();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedAd();
      },
    );
    _rewardedAd?.setImmersiveMode(true);
    _rewardedAd?.show(
      onUserEarnedReward: (ad, reward) {
        context.navigator.pop();
      },
    );
    _rewardedAd = null;
  }

  _showRewardedInterstitialAd() {
    _rewardedInterstitialAd?.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        context.navigator.pop();
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadRewardedInterstitialAd();
      },
    );
    _rewardedInterstitialAd?.setImmersiveMode(true);
    _rewardedInterstitialAd?.show(
      onUserEarnedReward: (ad, reward) {
        context.navigator.pop();
      },
    );
    _rewardedInterstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final config = FirebaseRemoteConfig.instance;
    final rewardTier2 = config.getInt('rewardTier2');
    final rewardTier3 = config.getInt('rewardTier3');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: const Text('Level 1'),
          subtitle: const Text('Support developer'),
          leading: const Icon(Icons.favorite),
          trailing: TextButton.icon(
            onPressed: _interstitialAd != null ? _showInterstitialAd : null,
            icon: _interstitialAd != null
                ? const Icon(Icons.check)
                : const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            label: Text(_interstitialAd == null ? 'Loading Ad' : 'Watch Ad'),
          ),
        ),
        ListTile(
          title: const Text('Level 2'),
          subtitle: Text('+$rewardTier2 tokens'),
          leading: const Icon(Icons.battery_4_bar),
          trailing: TextButton.icon(
            onPressed: _rewardedInterstitialAd != null
                ? _showRewardedInterstitialAd
                : null,
            icon: _rewardedInterstitialAd != null
                ? const Icon(Icons.check)
                : const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            label: Text(
                _rewardedInterstitialAd == null ? 'Loading Ad' : 'Watch Ad'),
          ),
        ),
        ListTile(
          title: const Text('Level 3'),
          subtitle: Text('+$rewardTier3 tokens'),
          leading: const Icon(Icons.battery_6_bar),
          trailing: TextButton.icon(
            onPressed: _rewardedAd != null ? _showRewardedAd : null,
            icon: _rewardedAd != null
                ? const Icon(Icons.check)
                : const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
            label: Text(_rewardedAd == null ? 'Loading Ad' : 'Watch Ad'),
          ),
        ),
      ],
    );
  }
}
