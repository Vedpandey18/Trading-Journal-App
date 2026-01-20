import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

/// AdMob Service
/// Handles Google AdMob integration
/// Shows ads only for Free users
class AdMobService {
  // Test Ad Unit IDs (Replace with your actual Ad Unit IDs from AdMob)
  // For Android
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111'; // Test ID
  static const String androidInterstitialAdUnitId = 'ca-app-pub-3940256099942544/1033173712'; // Test ID
  
  // For iOS
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716'; // Test ID
  static const String iosInterstitialAdUnitId = 'ca-app-pub-3940256099942544/4411468910'; // Test ID

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return androidBannerAdUnitId;
    } else if (Platform.isIOS) {
      return iosBannerAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return androidInterstitialAdUnitId;
    } else if (Platform.isIOS) {
      return iosInterstitialAdUnitId;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  /// Initialize AdMob
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// Create Banner Ad
  static BannerAd createBannerAd({
    required AdSize adSize,
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
        onAdOpened: (Ad ad) => print('Banner ad opened.'),
        onAdClosed: (Ad ad) => print('Banner ad closed.'),
      ),
    )..load();
  }

  /// Create Interstitial Ad
  static InterstitialAd? createInterstitialAd({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    InterstitialAd? interstitialAd;
    
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          onAdLoaded(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          onAdFailedToLoad(error);
        },
      ),
    );
    
    return interstitialAd;
  }
}

/// Ad Placement Strategy:
/// 
/// 1. **Banner Ads (Bottom of Screen)**
///    - Show on Dashboard, Trades List, Analytics (Free users only)
///    - Non-intrusive, always visible
///    - Refresh every 60 seconds
/// 
/// 2. **Interstitial Ads (Full Screen)**
///    - Show after every 5 trades added (Free users)
///    - Show when opening Analytics (Free users)
///    - Show maximum once per session
///    - Don't show during critical actions
/// 
/// 3. **Ad-Free Experience (Pro Users)**
///    - No ads shown for PRO_MONTHLY or PRO_YEARLY users
///    - This is a key selling point
