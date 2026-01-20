import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../services/admob_service.dart';

/// Ad Banner Widget
/// Shows banner ad at bottom of screen (Free users only)
class AdBannerWidget extends StatefulWidget {
  final AdSize adSize;
  
  const AdBannerWidget({
    Key? key,
    this.adSize = AdSize.banner,
  }) : super(key: key);

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    // Only show ads for Free users
    if (subscriptionProvider.isProUser) {
      return;
    }

    _bannerAd = AdMobService.createBannerAd(
      adSize: widget.adSize,
      onAdLoaded: (Ad ad) {
        setState(() {
          _isAdLoaded = true;
        });
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('Banner ad failed to load: $error');
        ad.dispose();
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, _) {
        // Don't show ads for Pro users
        if (subscriptionProvider.isProUser) {
          return const SizedBox.shrink();
        }

        // Show ad if loaded
        if (_isAdLoaded && _bannerAd != null) {
          return Container(
            alignment: Alignment.center,
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd!),
          );
        }

        // Show placeholder while loading
        return Container(
          height: widget.adSize.height.toDouble(),
          color: Colors.grey.shade200,
          child: const Center(
            child: Text(
              'Ad',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
