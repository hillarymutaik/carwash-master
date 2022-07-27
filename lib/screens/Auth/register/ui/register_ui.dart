import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Auth/login.dart';
import 'package:carwash/widget/formbuildtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import "package:images_picker/images_picker.dart";

import '../../forgotPassword/ui/forgotPassword_ui.dart';

class RegisterPage extends StatefulWidget {
  final String country, number;

  const RegisterPage({Key? key, required this.country, required this.number})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _registerPageState();
  }
}

class _registerPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormBuilderState>();
  final ImagePicker _picker = ImagePicker();
  File? image;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var safeHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appBar(context, locale.register!),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: safeHeight,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            // color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      height: safeHeight * 0.23,
                      child: image == null
                          ? InkWell(
                              onTap: () => imagePicker(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image(
                                  image: AssetImage(
                                    Assets.plc_profile,
                                  ),
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: image != null
                                  ? Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : SizedBox()),
                    ),
                    InkWell(
                      onTap: () => imagePicker(),
                      child: Container(
                          alignment: Alignment.center,
                          height: 27,
                          width: 27,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(colors: [
                                Color(0xff29ee86),
                                Color(0xff3fa0d7)
                              ])),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    FormBuilder(
                      child: Column(children: [
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Enter full name",
                            attribute: "fullname",
                            dividerColor: 0xff1F1C34,
                            errorText: "Enter full name first",
                            font: "Poppins",
                            keybordType: TextInputType.text,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            formType: "text",
                            dropDownList: [],
                            submitAction: () {}),
                        Divider(),
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Enter email address",
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
                        Divider(),
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Confirm password",
                            attribute: "confirmPassword",
                            dividerColor: 0xff1F1C34,
                            errorText: "Enter password first",
                            font: "Poppins",
                            keybordType: TextInputType.text,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            formType: "text",
                            dropDownList: [],
                            submitAction: () {}),
                        Divider(),
                      ]),
                      key: formKey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                isLoading == false
                    ? GestureDetector(
                        child: GradientButton("Sign Up"),
                        onTap: () {
                          if (formKey.currentState!.saveAndValidate()&&image!=null) {
                            setState(() {
                              isLoading = true;
                            });
                            FirebaseAuthClass().createUser(
                                image!,
                                widget.number,
                                formKey.currentState!.value['fullname'],
                                widget.country,
                                formKey.currentState!.value['email'],
                                formKey.currentState!.value['password'], () {
                              //successFunction
                              print("successful");
                              setState(() {
                                isLoading = false;
                              });
                              Get.off(Login());
                              Fluttertoast.showToast(
                                  msg: "Welcome to Barcade car wash.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            }, () {
                              //failedFunction
                              setState(() {
                                isLoading = false;
                              });
                              print("failed");
                              Fluttertoast.showToast(
                                  msg:
                                      "Something happened. Check your interenet connection and try again.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            }, () {
                              //weekPassword
                              print("weak-password");
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(
                                  msg:
                                      "Password requires more than 6 characters",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            }, () {
                              //userFound
                              print("user-found");
                              setState(() {
                                isLoading = false;
                              });
                              Fluttertoast.showToast(
                                  msg:
                                      "It seems like this account belongs to someone. Try another one",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                            });
                          }else{
                             Fluttertoast.showToast(
                                    msg: "Pick an image first",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                          }
                        },
                      )
                    : CircularProgressIndicator(),
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

  void imagePicker() async {
    XFile? Image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(Image!.path);
    });
    // List<Media>? res = await ImagesPicker.pick(
    //   count: 3,
    //   pickType: PickType.image,
    // );
    print("---------------------------${Image.toString()}");
  }
}
