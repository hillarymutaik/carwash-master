import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

bool isDirectionRTL(BuildContext context) {
  return intl.Bidi.isRtlLanguage(Localizations.localeOf(context).languageCode);
}

class QuickWashServices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    return FadedSlideAnimation(
      Stack(
        alignment:
            isDirectionRTL(context) ? Alignment.topLeft : Alignment.topRight,
        children: [
          Container(
            color: Colors.white,
            height: 125,
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(Assets.layer_4),
                  ),
                  title: Text(
                    locale.dummyStore1!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(locale.dummyAddress1!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.lightGreen)),
                      child: Icon(
                        Icons.call,
                        color: Colors.green,
                        size: 13,
                      ),
                    ),
                    Column(
                      children: [
                        Text(locale.distance!),
                        Text(locale.dummyDistance!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))
                      ],
                    ),
                    Column(
                      children: [
                        Text(locale.cost!),
                        Text("Ksh 60",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black))
                      ],
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.lightGreen)),
                      child: Text(
                        locale.bookNow!,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: isDirectionRTL(context)
                ? const EdgeInsets.only(left: 15)
                : const EdgeInsets.only(right: 15),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(gradient: gradient),
              child: Row(
                children: [
                  Text(
                    locale.dummyRating!,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.star, size: 10, color: Colors.white)
                ],
              ),
            ),
          ),
        ],
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
