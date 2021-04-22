import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zaanassh/services/ads/ad_helper.dart';

import '../navigation_bar.dart';

class IntertialAdsScreen extends StatefulWidget {
  @override
  _IntertialAdsScreenState createState() => _IntertialAdsScreenState();
}

class _IntertialAdsScreenState extends State<IntertialAdsScreen> {
  InterstitialAd _interstitialAd;

  @override
  void initState() {
    _interstitialAd = InterstitialAd(
      request: AdRequest(),
      adUnitId: AddHelper.interstitialAdUnitId,
      listener: AdListener(onAdClosed: (ad) {
        print("Add closed");

        //
        Get.to(() => NavigationBarScreen());
        _interstitialAd?.dispose();
      }, onAdOpened: (ad) {
        print("Add opened");
      }, onAdFailedToLoad: (ad, error) {
        print("Ad load falied $error");
      }),
    );

    _interstitialAd.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
