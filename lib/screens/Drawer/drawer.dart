import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Auth/login.dart';
import 'package:carwash/screens/Drawer/allBoookings/mybookings.dart';
import 'package:carwash/screens/Drawer/contactUs/contactUs.dart';
import 'package:carwash/screens/Drawer/favourites/favourites.dart';
import 'package:carwash/screens/Drawer/myAddresses/myAddress.dart';
import 'package:carwash/screens/Drawer/myCars/myCars.dart';
import 'package:carwash/screens/Drawer/profile/profile.dart';
import 'package:carwash/screens/Drawer/selectLanguage/selectLanguage.dart';
import 'package:carwash/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  BannerAd? _anchoredBanner;
  bool _loadingAnchoredBanner = false;

  Future<void> _createAnchoredBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    final BannerAd banner = BannerAd(
      size: size,
      request: request,
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _anchoredBanner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Builder(builder: (BuildContext context) {
      if (!_loadingAnchoredBanner) {
        _loadingAnchoredBanner = true;
        _createAnchoredBanner(context);
      }
      return Drawer(
        child: Container(
          color: Theme.of(context).backgroundColor,
          child: ListView(
            children: [
              DrawerHeader(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("userDetails")
                            .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return snapshot.connectionState != ConnectionState.waiting &&
                          snapshot.data!.docs.isNotEmpty
                      ?  Column(
                            children: [
                              FadedScaleAnimation(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    snapshot.data!.docs[0]['imageUrl'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                durationInMilliseconds: 400,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data!.docs[0]['fullname'],
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ):SizedBox();
                        }),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfile()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          locale.viewProfile!,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                    )
                  ],
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).backgroundColor),
              ),
              // if (_anchoredBanner != null)
              //   Container(
              //     width: _anchoredBanner!.size.width.toDouble(),
              //     height: _anchoredBanner!.size.height.toDouble(),
              //     child: AdWidget(ad: _anchoredBanner!),
              //   ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyBookings()));
                },
                child: DrawerListTile(
                    Icon(
                      Icons.verified_user,
                      color: iconFgColor,
                    ),
                    locale.myBookings),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCars()));
                },
                child: DrawerListTile(
                    Icon(Icons.drive_eta, color: iconFgColor), locale.myCars),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAddresses()));
                },
                child: DrawerListTile(
                    Icon(Icons.location_on, color: iconFgColor),
                    locale.myAddresses),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Favourites()));
              //   },
              //   child: DrawerListTile(
              //       Icon(Icons.favorite_outlined, color: iconFgColor),
              //       locale.favourites),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectLanguage()));
                },
                child: DrawerListTile(Icon(Icons.language, color: iconFgColor),
                    locale.changeLanguage),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUs()));
                },
                child: DrawerListTile(
                    Icon(Icons.mail, color: iconFgColor), locale.contactUs),
              ),
              InkWell(
                onTap: (() => FirebaseAuth.instance.signOut().then((value) => Get.offAll(Login()))),
                child: DrawerListTile(
                    Icon(Icons.exit_to_app, color: iconFgColor), locale.logout),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }
}
