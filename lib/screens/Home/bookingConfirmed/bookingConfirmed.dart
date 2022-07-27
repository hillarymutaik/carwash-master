import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Drawer/allBoookings/mybookings.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:get/get.dart';

class BookingConfirmed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: FadedSlideAnimation(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: SizedBox()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadedScaleAnimation(
                    Container(
                      child: Container(
                        color: Colors.transparent,
                        height: deviceHeight * 0.2,
                        child: Image.asset(
                          Assets.logo,
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    durationInMilliseconds: 400,
                  ),
                  Column(
                    children: [
                      Text(locale.bookingConfirmed!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 20)),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        locale.sitBackAndRelax!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(locale.haveAGreatDay!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 15),
                          textAlign: TextAlign.center)
                    ],
                  )
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            GestureDetector(
                onTap: () {
                  Get.off(MyBookings());
                },
                child: RectGradientButton("Track Progress"))
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
