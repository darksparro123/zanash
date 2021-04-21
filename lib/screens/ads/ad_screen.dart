import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zaanassh/services/ads/ad_helper.dart';

class AdScreenState {
  InterstitialAd _interstitialAd;
  bool adLoaded = false;

  void loadAd(Widget pageName) {
    try {
      _interstitialAd = InterstitialAd(
        request: AdRequest(),
        adUnitId: AddHelper.interstitialAdUnitId,
        listener: AdListener(onAdClosed: (ad) {
          print("Add closed");

          _interstitialAd?.dispose();
          Get.to(() => pageName);
        }, onAdOpened: (ad) {
          print("Add opened");
        }, onAdFailedToLoad: (ad, error) {
          print("Ad load falied $error");
        }),
      );

      _interstitialAd.load();
    } catch (e) {
      print("lLoad ad failed $e");
    }
  }
}
