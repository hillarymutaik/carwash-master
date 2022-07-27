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
import '../components/map.dart';

class ViewBooking extends StatefulWidget {
  final String id;

  const ViewBooking({Key? key, required this.id}) : super(key: key);
  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<ViewBooking> {
  bool switchValue = true;

  List locationList = [];
  final formKey = GlobalKey<FormBuilderState>();
  String car = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var safeHeight = MediaQuery.of(context).size.height -
    //     AppBar().preferredSize.height -
    //     MediaQuery.of(context).padding.vertical;
    var locale = AppLocalizations.of(context)!;
    bool showBookingDetails = false;

    TextStyle whiteFont =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14);
    return Scaffold(
      appBar: appBar(context, locale.bookingDetails!),
      body: FadedSlideAnimation(
        Stack(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("bookings")
                    .where("uid", isEqualTo: widget.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return snapshot.connectionState != ConnectionState.waiting &&
                          snapshot.data!.docs.isNotEmpty
                      ? ListView(
                          physics: BouncingScrollPhysics(),
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FormBuilder(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          child: MapPage(),
                                          height: 400,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Visibility(
                                            visible: showBookingDetails,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RadiantGradientMask(
                                                        child: Text(
                                                          locale.carSelected!,
                                                          style: whiteFont
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xff29ee86)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        snapshot.data!.docs[0]
                                                            ['carSelection'],
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffCCCCCC)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          RadiantGradientMask(
                                                            child: Text(
                                                              locale
                                                                  .arrangePickupAndDrop!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: whiteFont
                                                                  .copyWith(
                                                                      color: Color(
                                                                          0xff29ee86)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 2,
                                                      ),
                                                      Text(
                                                          locale
                                                              .serviceProviderWillpickup!,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText2!
                                                              .copyWith(
                                                                  color:
                                                                      subtitle)),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${snapshot.data!.docs[0]['pickupLocation']}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffCCCCCC)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RadiantGradientMask(
                                                        child: Text(
                                                          locale.datetime!,
                                                          style: whiteFont
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xff29ee86)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${snapshot.data!.docs[0]['dateTime']}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffCCCCCC)),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "${snapshot.data!.docs[0]['pickUpTime']}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffCCCCCC)),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RadiantGradientMask(
                                                        child: Text(
                                                          locale
                                                              .servicesSelected!,
                                                          style: whiteFont
                                                              .copyWith(
                                                                  color: Color(
                                                                      0xff29ee86)),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "Ksh ${snapshot.data!.docs[0]['serviceType']}",
                                                        style: whiteFont,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        locale.amountPaid!,
                                                        style: whiteFont,
                                                      ),
                                                      RadiantGradientMask(
                                                        child: Text(
                                                          "Ksh ${snapshot.data!.docs[0]['payableAmount']} ",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          18),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                              ],
                                            )),
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
                                        ProgessWidget(
                                          acceptanceTime: snapshot.data!
                                              .docs[0]['vendorAcceptiance']
                                              .toString(),
                                          dropOffTime: snapshot
                                              .data!.docs[0]['dropOffTime']
                                              .toString(),
                                          pickupTime: snapshot
                                              .data!.docs[0]['driverPickUp']
                                              .toString(),
                                          requestedTime: snapshot
                                              .data!.docs[0]['requestedTime']
                                              .toString(),
                                          servicedTime: snapshot
                                              .data!.docs[0]['serviceTime']
                                              .toString(),
                                          uid: widget.id,
                                          completionTime: snapshot
                                              .data!.docs[0]['completionTime']
                                              .toString(),
                                          assignedRider: snapshot
                                              .data!.docs[0]['rider']
                                              .toString(),
                                          deviceToken: snapshot.data!.docs[0]
                                              ['assigner'],
                                          riderWithCar: snapshot
                                              .data!.docs[0]['rider']
                                              .toString(),
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
                        )
                      : SizedBox();
                })
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
