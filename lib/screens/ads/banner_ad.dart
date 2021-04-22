import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zaanassh/services/ads/ad_helper.dart';

class BannerAdScreen extends StatefulWidget {
  @override
  _BannerAdScreenState createState() => _BannerAdScreenState();
}

class _BannerAdScreenState extends State<BannerAdScreen> {
  BannerAd _ad;
  bool adLoaded = false;
  @override
  void initState() {
    _ad = BannerAd(
      adUnitId: AddHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: AdListener(
        onAdLoaded: (_) {
          print("ad loaded");
          setState(() {
            adLoaded = true;
          });
        },
        onAdClosed: (_) => print("ad is closed"),
        onAdFailedToLoad: (_, e) => print("Ad load failed $e"),
      ),
    );
    _ad.load();
    super.initState();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (!adLoaded)
        ? Container(
            child: Center(
              child: SpinKitCubeGrid(
                color: Colors.amber[400],
              ),
            ),
          )
        : Container(
            child: AdWidget(ad: _ad),
            width: _ad.size.width.toDouble(),
            height: _ad.size.height.toDouble(),
            alignment: Alignment.center,
          );
  }
}
