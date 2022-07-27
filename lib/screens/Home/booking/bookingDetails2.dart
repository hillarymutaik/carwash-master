import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Drawer/addLocation/addLocation.dart';
import 'package:carwash/screens/Home/addCar/addCar.dart';
import 'package:carwash/screens/Home/payment/paymentMethods.dart';
import 'package:carwash/style/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../widget/progress.dart';
import '../bookingConfirmed/bookingConfirmed.dart';

class BookingDetails2 extends StatefulWidget {
  final bool newBooking;
  final List locationList;
  final double finalPrice;
  final String serviceType, car, whenDate, whenTime;
  BookingDetails2(this.newBooking, this.locationList, this.finalPrice,
      this.serviceType, this.car, this.whenDate, this.whenTime);

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails2> {
  bool switchValue = true;
  List carList = [];
  List locationList = [];
  final formKey = GlobalKey<FormBuilderState>();
  String car = "";
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadiantGradientMask(
                                    child: Text(
                                      "Service type",
                                      style: whiteFont.copyWith(
                                          color: Color(0xff29ee86)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    widget.serviceType,
                                    style: TextStyle(color: Color(0xffCCCCCC)),
                                  ),
                                ],
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
                                        locale.carSelected!,
                                        style: whiteFont.copyWith(
                                            color: Color(0xff29ee86)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.car,
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
                                            locale.arrangePickupAndDrop!,
                                            overflow: TextOverflow.ellipsis,
                                            style: whiteFont.copyWith(
                                                color: Color(0xff29ee86)),
                                          ),
                                        ),
                                        widget.newBooking
                                            ? Container(
                                                height: 5,
                                                // width: 60,
                                                child: Switch(
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    activeColor: iconFgColor,
                                                    value: switchValue,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        switchValue = val;
                                                      });
                                                    }),
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(locale.serviceProviderWillpickup!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(color: subtitle)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    switchValue != true
                                        ? SizedBox()
                                        : widget.locationList.isNotEmpty
                                            ? FormBuilderDropdown(
                                                name: 'location',
                                                style: TextStyle(
                                                    color: Colors.white),
                                                decoration:
                                                    const InputDecoration(
                                                        hintStyle:
                                                            TextStyle(
                                                                color: Colors
                                                                    .white),
                                                        border:
                                                            InputBorder.none),
                                                // initialValue: 'Male',
                                                allowClear: false,
                                                hint: const Text(
                                                  'Select a location',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                validator: FormBuilderValidators
                                                    .compose([
                                                  FormBuilderValidators
                                                      .required(context)
                                                ]),
                                                items: widget.locationList
                                                    .map((gender) =>
                                                        DropdownMenuItem(
                                                          value: gender,
                                                          child: Text(
                                                            gender,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffCCCCCC)),
                                                          ),
                                                        ))
                                                    .toList(),
                                              )
                                            : InkWell(
                                                onTap: () =>
                                                    Get.to(AddLocation()),
                                                child: RadiantGradientMask(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Add an address",
                                                      style: whiteFont.copyWith(
                                                          color: Color(
                                                              0xff29ee86)),
                                                    ),
                                                  ),
                                                ),
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
                                        locale.datetime!,
                                        style: whiteFont.copyWith(
                                            color: Color(0xff29ee86)),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.whenDate,
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC)),
                                        ),
                                        Text(
                                          widget.whenTime,
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC)),
                                        ),
                                      ],
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
                                      child: Text(
                                        widget.serviceType,
                                        style:
                                            TextStyle(color: Color(0xffCCCCCC)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(),
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
                                        "Ksh ${widget.finalPrice}",
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
                              Divider(),
                              RadiantGradientMask(
                                child: Text(
                                  "Progress",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 18),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                  onTap: () {
                    print("onTap............");

                    if (formKey.currentState!.saveAndValidate()) {
                      print("form key valid...............");
                      bookingAdding(() {
                        //successful
                        Get.off(BookingConfirmed());
                      }, () {
                        //failed
                        Get.snackbar("Booking", "Failed to make your booking.");
                      });
                    }
                  },
                  child: RectGradientButton("Finilaze")),
            )
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
  void bookingAdding(successful, failed) {
    var uid =
        "${firebaseAuth.currentUser!.uid}-booking- ${DateTime.now().millisecondsSinceEpoch}";
    fireStoreInstance
        .collection("bookings")
        .doc(uid)
        .set({
          "serviceType": widget.serviceType,
          "carSelection": widget.car,
          "pickUp": true,
          "requestedTime": DateTime.now().millisecondsSinceEpoch,
          "payableAmount": widget.finalPrice,
          "dateTime": widget.whenDate,
          "vendorAcceptiance": "",
          "pickUpTime": DateTime.now().millisecondsSinceEpoch,
          "serviceTime": "",
          "completionTime": "",
          "uid": uid,
          "done":"Ongoing",
          "dropOffTime": "",
          "rider":"",
          "ownerID": firebaseAuth.currentUser!.uid,
          "pickupLocation": formKey.currentState!.value['location']
        })
        .then((value) => successful())
        .onError((error, stackTrace) {
          print("-----this is an error msg : $error");
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
  }
}
