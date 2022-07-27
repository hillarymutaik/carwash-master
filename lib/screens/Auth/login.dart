import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Auth/register/ui/register_ui.dart';
import 'package:carwash/screens/Auth/signin/backend/countries.dart';
import 'package:carwash/screens/Auth/signin/ui/signin_ui.dart';
import 'package:carwash/screens/Home/home.dart';
import 'package:carwash/widget/formbuildtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Login> {
  String? _country;
  final formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FadedSlideAnimation(
        Stack(
          // alignment: Alignment.bottomCenter,
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.transparent,
                Theme.of(context).backgroundColor
              ], begin: Alignment.topCenter)),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.splashBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: deviceHeight,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Spacer(flex: 3),

                    // Row(
                    //   children: [
                    Container(
                      color: Colors.transparent,
                      height: deviceHeight * 0.2,
                      child: Image.asset(
                        Assets.logo,
                        width: MediaQuery.of(context).size.width,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        FormBuilder(
                          child: Column(children: [
                            formbuildtextfield(
                                height: 40,
                                color: 0xffFFFFFF,
                                hintText: "Enter email",
                                attribute: "email",
                                dividerColor: 0xff1F1C34,
                                errorText: "Enter email first",
                                font: "Poppins",
                                keybordType: TextInputType.emailAddress,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                formType: "text",
                                dropDownList: [],
                                submitAction: () {}),
                            Divider(),
                            formbuildtextfield(
                                height: 40,
                                color: 0xffFFFFFF,
                                hintText: "Enter password",
                                attribute: "password",
                                dividerColor: 0xff1F1C34,
                                errorText: "Enter password first",
                                font: "Poppins",
                                keybordType: TextInputType.text,
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                formType: "text",
                                dropDownList: [],
                                submitAction: () {}),
                            Divider()
                          ]),
                          key: formKey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        isLoading == false
                            ? GestureDetector(
                                onTap: () {
                                  if (formKey.currentState!.saveAndValidate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    FirebaseAuthClass().loginUserAsSeller(
                                        formKey.currentState!.value['email'],
                                        formKey.currentState!.value['password'],
                                        () {
                                      //successFunction
                                      Get.offAll(HomeScreen());
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                    msg:
                                        "Welcome back ${formKey.currentState!.value['email']}",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Theme.of(context).backgroundColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                    }, () {
                                      //failedFunction
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Fluttertoast.showToast(
                                    msg:
                                        " Something happened.Check your internet connection and try again.",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Theme.of(context).backgroundColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                                    });
                                  }
                                },
                                child: GradientButton("Login"),
                              )
                            : CircularProgressIndicator(),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Forgot password",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          child: GradientButton("Create account"),
                          onTap: () {
                            Get.to(Signin());
                          },
                        )
                        // SizedBox(
                        //   height: 20,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //         child: SocialButtons(
                        //             locale.facebook, Color(0xff29ee86))),
                        //     Expanded(
                        //         child: SocialButtons(
                        //             locale.google, Color(0xff3fa0d7))),
                        //   ],
                        // )
                      ],
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
