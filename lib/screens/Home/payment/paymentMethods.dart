import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/screens/Home/bookingConfirmed/bookingConfirmed.dart';
import 'package:carwash/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mpesa_flutter_plugin/initializer.dart';
import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';

import '../../../widget/formbuildtextfield.dart';

class PaymentMethods extends StatefulWidget {
  final double finalPrice;

  const PaymentMethods({Key? key, required this.finalPrice}) : super(key: key);
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  int? group;
  int? indexValue;
  bool useMyno = false;
  bool isLoading = false;
  String registeredNumber = "";
  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    // var selected = 1;
    List titles = ["Mpesa services", "Cash on delivery"];
    return FadedSlideAnimation(
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(
                Icons.chevron_left,
                color: iconFgColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(locale.payment!),
          actions: [],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      RadiantGradientMask(
                        child: Text(
                            locale.amountPayable! + " Ksh ${widget.finalPrice}",
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontSize: 15,
                                      color: Color(0xff29ee86),
                                    )),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      color: Theme.of(context).backgroundColor,
                      margin: EdgeInsets.symmetric(vertical: 3),
                      child: RadioListTile(
                        title: Text(titles[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 15)),
                        activeColor: Color(0xff29ee86),
                        value: index,
                        groupValue: group,
                        onChanged: (dynamic val) {
                          setState(() {
                            group = val;
                            indexValue = index;
                          });
                        },
                      ),
                    );
                  },
                ),
                Visibility(
                    visible: indexValue == 0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            child: RadiantGradientMask(
                                child: Text(
                                    "Enter the Mpesa number you wish to pay with.")),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Use the number i regested with."),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 5,
                                  // width: 60,
                                  child: Switch(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: iconFgColor,
                                      value: useMyno,
                                      onChanged: (val) {
                                        setState(() {
                                          useMyno = val;
                                        });
                                        getUserPhoneNumber();
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: useMyno != true,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FormBuilder(
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
                          ),
                        )
                      ],
                    ))
              ],
            ),
           isLoading==false? GestureDetector(
                onTap: () {
                  if (indexValue == 0) {
                    if (formKey.currentState!.saveAndValidate()) {
                      lipaNaMpesa(
                          "Barcade car wash",
                          "UUID",
                          registeredNumber != ""
                              ? registeredNumber
                              : formKey.currentState!.value['number']
                                      .toString()
                                      .startsWith("07")
                                  ? "254${formKey.currentState!.value['number'].toString().substring(1)}"
                                  : formKey.currentState!.value['number'],
                          widget.finalPrice,
                          "Car wash", () {
                        //successful
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookingConfirmed()));
                      }, () {
                        //failed
                        Fluttertoast.showToast(
                            msg:
                                "Invalid phone fomate (start with 254). Try again",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Theme.of(context).backgroundColor,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      });
                    }
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingConfirmed()));
                  }
                },
                child: RectGradientButton(locale.payNow)):SizedBox(width: 50,height: 50,child: CircularProgressIndicator(),)
          ],
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }

  ///payment using MPESA ONLINE PAYMENT using APIs.....
  Future<void> lipaNaMpesa(String receiverID, String UUID, String phoneNumber,
      double amount, String productName, successful, failed) async {
    // ignore: unused_local_variable
    String mPasskey =
        'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919';
    dynamic transactionInitialisation;
    try {
      transactionInitialisation =
          await MpesaFlutterPlugin.initializeMpesaSTKPush(
              businessShortCode: "174379",
              transactionType: TransactionType.CustomerPayBillOnline,
              amount: amount,
              partyA: phoneNumber,
              partyB: "174379",
              callBackURL: Uri(
                  scheme: "https",
                  host: "us-central1-carwash-3a5f9.cloudfunctions.net",
                  path: "mpesaApis/callBackUrl"),
              accountReference:
                  FirebaseAuth.instance.currentUser!.email.toString(),
              phoneNumber: phoneNumber,
              baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
              transactionDesc: "purchased $productName @ amount $amount",
              passKey: mPasskey);
//This passkey has been generated from Test Credentials from Safaricom Portal
      print(transactionInitialisation);
      if (transactionInitialisation.toString().contains(
          "ResponseCode: 0, ResponseDescription: Success. Request accepted for processing, CustomerMessage: Success.")) {
        print("success");
        // confirmPayment("value", receiverID, UUID, () {
        //   Get.back();
        // }, () {
        //   failed();
        // }, transactionInitialisation);
        successful();
      } else {}

      return transactionInitialisation;
    } catch (e) {
      print("CAUGHT EXCEPTION: " + e.toString());
      print(print);
      failed(e.toString());
    }
  }

  final fireStoreInstance = FirebaseFirestore.instance;

  ///update after payment is done
  void confirmPayment(String value, String receiverID, String UUID,
      successFunction, failedFunction, var paymentDetails) async {
    Map<String, dynamic> payLoad = {
      "state": 'delivered',
      "orderCode": "",
      "paymentDetails": paymentDetails,
      "paymentTime": DateTime.now().millisecondsSinceEpoch,
    };
    //checking if the orderCode is the same as the one in the backend
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('userOrder')
        .get()
        .onError((error, stackTrace) => failedFunction());
    for (var i = 0; snapshot.docs.length > i; i++) {
      if (snapshot.docs[i]['orderCode']
          .toString()
          .toLowerCase()
          .contains(value.toString().toLowerCase())) {
        fireStoreInstance
            .collection("userOrder")
            .doc(UUID)
            .update(payLoad)
            .then((value) {
          successFunction();
        }).catchError((onError) {
          print(onError);
          failedFunction();
        });
      }
    }
  }

  //get the user phone number....
  void getUserPhoneNumber() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('userDetails')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    snapshot.docs.forEach((element) {
      setState(() {
        registeredNumber = element['phoneNumber'].toString().startsWith("07")
            ? "254${element['phoneNumber'].toString().substring(1)}"
            : element['phoneNumber'].toString();
      });
    });
    print(registeredNumber);
  }
}
