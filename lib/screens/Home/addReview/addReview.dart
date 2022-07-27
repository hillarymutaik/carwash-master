import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../backend/notification.dart';
import '../../../widget/formbuildtextfield.dart';

class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  bool one = false;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;

  double ratingValue = 0.0;

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: appBar(context, locale.addReview!),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              children: [
                Row(
                  children: [
                    FadedScaleAnimation(
                      SmoothStarRating(
                          allowHalfRating: true,
                          onRated: (rating) {
                            setState(() {
                              ratingValue = rating;
                            });
                          },
                          starCount: 5,
                          rating: ratingValue,
                          size: 40.0,
                          isReadOnly: false,
                          color: Colors.amber,
                          borderColor: Colors.amber,
                          spacing: 0.0),
                      durationInMilliseconds: 400,
                    ),
                  ],
                ),
                FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      formbuildtextfield(
                          height: 40,
                          color: 0xffFFFFFF,
                          hintText: locale.letUsKnowUrFeedbacks!,
                          attribute: "msg",
                          dividerColor: 0xff1F1C34,
                          errorText: "Enter review first",
                          font: "Poppins",
                          keybordType: TextInputType.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                          formType: "text",
                          dropDownList: [],
                          submitAction: () {}),
                      Divider(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        FirebaseAuthClass().makeRating(
                            formKey.currentState!.value['msg'], ratingValue,
                            () {
                          //succesful
                          FirebaseMessaging.instance.getToken().then((value) {
                            NotificationClass().sendPushNotificationToSeller(
                                "Thank you for rating Barcade car wash",
                                value.toString());

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          });
                        }, () {
                          //failed
                        });
                      }
                    },
                    child: GradientButton(locale.addReview))
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
