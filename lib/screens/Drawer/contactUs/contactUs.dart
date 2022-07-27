import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Drawer/drawer.dart';
import 'package:carwash/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:open_mail_app/open_mail_app.dart';

import '../../../widget/formbuildtextfield.dart';

class ContactUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var locale = AppLocalizations.of(context)!;

    final formKey = GlobalKey<FormBuilderState>();
    // var safeHeight = MediaQuery.of(context).size.height -
    //     AppBar().preferredSize.height -
    //     MediaQuery.of(context).padding.vertical;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: iconFgColor,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            }),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.vertical -
                AppBar().preferredSize.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(locale.wereHappyToHear!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 25)),
                SizedBox(
                  height: 15,
                ),
                Text(
                  locale.letUsKnowQueriesAndFeedbacks!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => makeCall(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.call,
                                  color: Color(0xff29ee86),
                                  size: 17,
                                ),
                              ),
                              Expanded(
                                child: Text(locale.callUs!,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(
                                          fontSize: 15,
                                          color: Color(0xff29ee86),
                                        )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => openEmail(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              gradient: gradient,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Icon(
                                  Icons.mail,
                                  color: Colors.white,
                                  size: 17,
                                ),
                              ),
                              Expanded(
                                child: Text(locale.mailUs!,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(fontSize: 15)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Icon(Icons.mail, color: Color(0xff29ee86)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(locale.sendYourMessage!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 17)),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(),
                Container(
                  child: FormBuilder(
                    key: formKey,
                    child: Column(children: [
                      formbuildtextfield(
                          height: 40,
                          color: 0xffFFFFFF,
                          hintText: "Write your message ",
                          attribute: "sms",
                          dividerColor: 0xff1F1C34,
                          errorText: "Enter message first",
                          font: "Poppins",
                          keybordType: TextInputType.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0,
                          formType: "text",
                          dropDownList: [],
                          submitAction: () {}),
                      Divider()
                    ]),
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 20,
            end: 20,
            child: GestureDetector(
                onTap: () {
                  if (formKey.currentState!.saveAndValidate()) {
                    sendSms(formKey.currentState!.value['sms']);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GradientButton(locale.submit),
                )),
          ),
        ],
      ),
    );
  }

  //make a phone call....
  void makeCall() async {
    const number = '0712345678'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  //open the email address...
  void openEmail() async {
    var result =
        await OpenMailApp.openMailApp(nativePickerTitle: "Help center");
  }

  //sending sms......
  void sendSms(String message) async {
    String _result = await sendSMS(message: message, recipients: ["071234567"])
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
