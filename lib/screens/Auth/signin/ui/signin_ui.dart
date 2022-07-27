import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Auth/register/ui/register_ui.dart';
import 'package:carwash/screens/Auth/signin/backend/countries.dart';
import 'package:carwash/widget/formbuildtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  String? _country;
  final formKey = GlobalKey<FormBuilderState>();

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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField(
                              dropdownColor: Theme.of(context).backgroundColor,
                              hint: Text(
                                locale.selectCountry!,
                                style: TextStyle(
                                  color:Color.fromARGB(255, 151, 151, 151)
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyText1,
                              items: Countries.map((country) {
                                return DropdownMenuItem(
                                  value: country,
                                  child: Container(child: Text(country)),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                setState(() => _country = newValue);
                              },
                              value: _country,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[800]!)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[800]!)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FormBuilder(
                          child: Column(children: [
                            formbuildtextfield(
                                height: 40,
                                color: 0xffFFFFFF,
                                hintText: "Enter phone number",
                                attribute: "number",
                                dividerColor: 0xff1F1C34,
                                errorText: "Enter phone number first",
                                font: "Poppins",
                                keybordType: TextInputType.number,
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
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.saveAndValidate()) {
                              if (_country!.isNotEmpty) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage(
                                            country: _country!,
                                            number: formKey.currentState!
                                                .value['number'])));
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Pick a country to continue",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    textColor: Colors.white,
                                    fontSize: 14.0);
                              }
                            }
                          },
                          child: GradientButton(locale.continuee),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          locale.orContinueWith!,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: SocialButtons(
                                    locale.facebook, Color(0xff29ee86))),
                            Expanded(
                                child: SocialButtons(
                                    locale.google, Color(0xff3fa0d7))),
                          ],
                        )
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
