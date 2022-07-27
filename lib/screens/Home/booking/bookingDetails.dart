import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/backend/notification.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Drawer/addLocation/addLocation.dart';
import 'package:carwash/screens/Home/addCar/addCar.dart';
import 'package:carwash/screens/Home/payment/paymentMethods.dart';
import 'package:carwash/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../widget/progress.dart';
import '../bookingConfirmed/bookingConfirmed.dart';

class BookingDetails extends StatefulWidget {
  final bool newBooking;
  final String carDetails;
  final List services;
  final whenTime, whenDate;
  final double finalPrice;
  BookingDetails(this.newBooking, this.services, this.finalPrice,
      this.carDetails, this.whenTime, this.whenDate);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool switchValue = true;
  List carList = [];
  List locationList = [];
  String locationAddress = "";
  final formKey = GlobalKey<FormBuilderState>();
  String car = "";
  bool changed = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTheCarList();
  }

  @override
  Widget build(BuildContext context) {
    // var safeHeight = MediaQuery.of(context).size.height -
    //     AppBar().preferredSize.height -
    //     MediaQuery.of(context).padding.vertical;
    var locale = AppLocalizations.of(context)!;

    TextStyle whiteFont =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14);
    return Scaffold(
      appBar: appBar(context,
          widget.newBooking ? locale.comfirmBooking! : locale.bookingDetails!),
      body: FadedSlideAnimation(
        Stack(
          children: [
            FormBuilder(
              child: ListView(
                physics: BouncingScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormBuilder(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadiantGradientMask(
                                      child: Text(
                                        locale.carSelected!,
                                        style: whiteFont.copyWith(
                                            color: Color(0xff29ee86)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.carDetails,
                                      style:
                                          TextStyle(color: Color(0xffCCCCCC)),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RadiantGradientMask(
                                          child: Text(
                                            locale.arrangePickupAndDrop! +
                                                " (Ksh: 100)",
                                            overflow: TextOverflow.ellipsis,
                                            style: whiteFont.copyWith(
                                                color: Color(0xff29ee86)),
                                          ),
                                        ),
                                        widget.newBooking
                                            ? CupertinoSwitch(
                                                activeColor: Colors.green,
                                                value: switchValue,
                                                onChanged: (val) {
                                                  setState(() {
                                                    switchValue = val;
                                                    changed = true;
                                                  });
                                                })
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                    Visibility(
                                        visible: switchValue,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  locale
                                                      .serviceProviderWillpickup!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2!
                                                      .copyWith(
                                                          color: subtitle)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Using your current location",
                                                style: whiteFont.copyWith(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            changed != true
                                                ? StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'usersAddress')
                                                        .where("uid",
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
                                                      return Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: InkWell(
                                                          child:
                                                              RadiantGradientMask(
                                                            child: Text(
                                                              "Change location.",
                                                              style: whiteFont
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              changed = true;
                                                            });
                                                            getTheCarList();
                                                          },
                                                        ),
                                                      );
                                                    })
                                                : locationList.isNotEmpty
                                                    ? FormBuilderDropdown(
                                                        name: 'carType',
                                                        decoration:
                                                            const InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        // initialValue: 'Male',
                                                        allowClear: false,
                                                        style: TextStyle(
                                                            color: Colors.grey),

                                                        hint: const Text(
                                                          'Select a location',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        validator:
                                                            FormBuilderValidators
                                                                .compose([
                                                          FormBuilderValidators
                                                              .required(context)
                                                        ]),
                                                        items: locationList
                                                            .map((gender) =>
                                                                DropdownMenuItem(
                                                                  value: gender,
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      locationAddress =
                                                                          gender;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      '$gender'
                                                                          .toLowerCase()),
                                                                ))
                                                            .toList(),
                                                      )
                                                    : SizedBox(
                                                        child:
                                                            RadiantGradientMask(
                                                          child: InkWell(
                                                            onTap: () {
                                                              Get.to(
                                                                  AddLocation());
                                                            },
                                                            child: Text(
                                                              "Add a location",
                                                              style: whiteFont
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadiantGradientMask(
                                      child: Text(
                                        locale.datetime!,
                                        style: whiteFont.copyWith(
                                            color: Color(0xff29ee86)),
                                      ),
                                    ),
                                    Text(
                                      "${widget.whenTime.toString().replaceAll("0001-01-01", "").replaceAll("00.000,", "00")}",
                                      style: whiteFont,
                                    ),
                                    Text(
                                      "${widget.whenDate.toString().replaceAll("00:00:00.000,", "")}",
                                      style: whiteFont,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RadiantGradientMask(
                                      child: Text(
                                        locale.servicesSelected!,
                                        style: whiteFont.copyWith(
                                            color: Color(0xff29ee86)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 70,
                                      child: ListView(
                                        children: widget.services
                                            .map(
                                              (e) => Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        e['name'],
                                                        style: whiteFont,
                                                      ),
                                                      Text(
                                                        "Ksh ${e['price']}",
                                                        style: whiteFont,
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 5)
                                                ],
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
                              switchValue == true
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Pick up fee",
                                            style: whiteFont,
                                          ),
                                          RadiantGradientMask(
                                            child: Text(
                                              "Ksh 100",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 18),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.newBooking
                                          ? locale.amountPayable!
                                          : locale.amountPaid!,
                                      style: whiteFont,
                                    ),
                                    RadiantGradientMask(
                                      child: Text(
                                        switchValue != true
                                            ? "Ksh ${widget.finalPrice}"
                                            : "Ksh ${widget.finalPrice + 100}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    key: formKey,
                  ),
                ],
              ),
            ),
            widget.newBooking
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                        onTap: () {
                          print("onTap............");

                          if (formKey.currentState!.saveAndValidate()) {
                            print("form key valid...............");
                            bookingAdding(() {
                              //successful
                              Get.off(PaymentMethods(
                                finalPrice: widget.finalPrice,
                              ));
                              FirebaseMessaging.instance
                                  .getToken()
                                  .then((value) {
                                NotificationClass().sendPushNotificationToSeller(
                                    "Your Request has been placed placed and awaiting acceptances from vendor.",
                                    value.toString());
                              });
                            }, () {
                              //failed
                              Get.snackbar(
                                  "Booking", "Failed to make your booking.");
                            });
                          }
                        },
                        child: RectGradientButton("Make payment")),
                  )
                : SizedBox.shrink(),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  //variables
  var firebaseAuth = FirebaseAuth.instance;

  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage storageReference = FirebaseStorage.instance;
  //add booking...
  void bookingAdding(successful, failed) async {
    var uid =
        "${firebaseAuth.currentUser!.uid}-booking-${DateTime.now().millisecondsSinceEpoch}";

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('providerDeviceToken')
        .where("email", isEqualTo: "admin@baracade.com")
        .get();

    snapshot.docs.forEach((element) {
      FirebaseMessaging.instance
          .getToken()
          .then(
              (value) => fireStoreInstance.collection("bookings").doc(uid).set({
                    "serviceType": "Manual & Pressuring cleaning",
                    "carSelection": widget.carDetails,
                    "pickUp": switchValue,
                    "requestedTime": DateTime.now().millisecondsSinceEpoch,
                    "services": widget.services,
                    "payableAmount": widget.finalPrice,
                    "dateTime": DateTime.now(),
                    "vendorAcceptiance": "",
                    "pickUpTime": DateTime.now(),
                    "driverPickUp": "",
                    "serviceTime": "",
                    "completionTime": "",
                    "uid": uid,
                    "done": "Ongoing",
                    "dropOffTime": "",
                    "rider": "",
                    "deviceToken": value,
                    "ownerID": firebaseAuth.currentUser!.uid,
                    "pickupLocation":
                        locationAddress != "" ? locationAddress : "",
                    "assigner": element['deviceToken']
                  }).then((value) {
                    NotificationClass().sendPushNotificationToSeller(
                        "A booking has been placed by ${FirebaseAuth.instance.currentUser!.email}",
                        element['deviceToken'].toString());
                    successful();
                  }).onError((error, stackTrace) {
                    print("-----this is an error msg : $error");
                  }))
          .onError((error, stackTrace) => null);
    });
  }

  void getTheCarList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usersCars')
        .where("ownerID", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    snapshot.docs.forEach((element) {
      if (carList.contains(
          "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}")) {
        carList.remove(element['location']);
        carList.add(
            "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}");
      } else {
        carList.add(
            "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}");
      }
    });
    print(carList);

    QuerySnapshot snapshotLocation = await FirebaseFirestore.instance
        .collection('usersAddress')
        .where("uid", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    snapshotLocation.docs.forEach((element) {
      if (locationList.contains(element['location'])) {
        locationList.remove(element['location']);
        locationList.add(element['location']);
      } else {
        locationList.add(element['location']);
      }
    });
    print(carList);
    await Future.delayed(Duration(seconds: 2)).then((value) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usersCars')
        .where("ownerID", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    snapshot.docs.forEach((element) {
      if (carList.contains(
          "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}")) {
        carList.remove(element['location']);
        carList.add(
            "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}");
      } else {
        carList.add(
            "${element['carBrand']}-${element['carModel']}-${element['carNoPlate']}");
      }
    });
    print(carList);

    QuerySnapshot snapshotLocation = await FirebaseFirestore.instance
        .collection('usersAddress')
        .where("uid", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    snapshotLocation.docs.forEach((element) {
      if (locationList.contains(element['location'])) {
        locationList.remove(element['location']);
        locationList.add(element['location']);
      } else {
        locationList.add(element['location']);
      }
    });
    });
  }
}
