import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/components/map.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/widget/formbuildtextfield.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddLocation extends StatefulWidget {
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  String currentIndex = "home";
  bool home = true;
  bool office = false;
  bool other = false;
  bool isLoading = false;

  String coordinates = "Enter location";

  final formKey = GlobalKey<FormBuilderState>();

  void getLocationText() async {}

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return FadedSlideAnimation(
      Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Text(
            locale.cancel!,
          ),
          actions: [],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //       image: DecorationImage(
            //           image: AssetImage(Assets.map), fit: BoxFit.cover)),
            // ),
            MapPage(),
            Container(
              height: 260,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Theme.of(context).primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.selectAddressType!),
                      Icon(
                        Icons.cancel_outlined,
                        color: Colors.grey[600],
                        size: 15,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = "home";
                          });
                        },
                        child: locationButtonGradient(context, Assets.ic_home,
                            locale.home!, currentIndex == "home"),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = "office";
                          });
                        },
                        child: locationButtonGradient(context, Assets.ic_office,
                            locale.office!, currentIndex == "office"),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = "other";
                          });
                        },
                        child: locationButtonGradient(
                            context,
                            Assets.ic_other_location,
                            locale.other!,
                            currentIndex == "other"),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FormBuilder(
                    child: formbuildtextfield(
                        height: 40,
                        color: 0xffFFFFFF,
                        hintText: "$coordinates",
                        attribute: "location",
                        dividerColor: 0xff1F1C34,
                        errorText: "Enter location first",
                        font: "Poppins",
                        keybordType: TextInputType.text,
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        formType: "text",
                        dropDownList: [],
                        submitAction: () {}),
                    key: formKey,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  isLoading == false
                      ? GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              if (currentIndex != "") {
                                setState(() {
                                  isLoading = true;
                                });
                                FirebaseAuthClass().addAddress(
                                    formKey.currentState!.value['location'],
                                    currentIndex, () {
                                  //succesful
                                  Get.back();
                                  setState(() {
                                    isLoading = false;
                                  });
                                }, () {
                                  //failed
                                  Fluttertoast.showToast(
                                      msg: "Failed to add location",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Theme.of(context).backgroundColor,
                                      textColor: Colors.white,
                                      fontSize: 14.0);
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Pick address type first",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: GradientButton(locale.save))
                      : Center(
                          child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 40,
                          height: 40,
                        ))
                ],
              ),
            ),
          ],
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }

  ///
  ///
  ///adding location......

}

Container locationButtonGradient(
    BuildContext context, var icon, String text, bool colored) {
  return Container(
    decoration: colored
        ? BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(25))
        : BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(25)),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: FadedScaleAnimation(
            Image(
              image: AssetImage(
                icon,
              ),
            ),
            durationInMilliseconds: 400,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 12),
        )
      ],
    ),
  );
}
