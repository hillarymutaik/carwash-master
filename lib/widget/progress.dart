import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/screens/Home/addReview/addReview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

import '../backend/notification.dart';
import '../components/widgets.dart';
import 'text_widget.dart';

class ProgessWidget extends StatefulWidget {
  final String requestedTime,
      acceptanceTime,
      pickupTime,
      servicedTime,
      dropOffTime,
      uid,
      completionTime,
      assignedRider,
      deviceToken,
      riderWithCar;

  const ProgessWidget(
      {Key? key,
      required this.requestedTime,
      required this.acceptanceTime,
      required this.pickupTime,
      required this.servicedTime,
      required this.dropOffTime,
      required this.uid,
      required this.completionTime,
      required this.assignedRider,
      required this.deviceToken,
      required this.riderWithCar})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ProgessWidgetState();
  }
}

class _ProgessWidgetState extends State<ProgessWidget> {
  @override
  Widget build(BuildContext context) {
    TextStyle whiteFont =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14);
    return Column(
      children: [
        Visibility(
            visible: widget.completionTime == "",
            child: Column(
              children: [
                widget.riderWithCar != ""
                    ? InkWell(
                        child: GradientButton("Release to Rider"),
                        onTap: () {
                          FirebaseAuthClass().changeProgress(
                              DateTime.now().toString(),
                              "driverPickUp",
                              widget.uid,
                              context);
                        },
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                widget.acceptanceTime != ""
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("stuffMembers")
                            .where("uid", isEqualTo: widget.assignedRider)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return snapshot.connectionState !=
                                      ConnectionState.waiting &&
                                  snapshot.data!.docs.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[0]
                                                      ['imageUrl']),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            makeCall(snapshot.data!.docs[0]
                                                ['phoneNo']);
                                          },
                                          child: RadiantGradientMask(
                                              child: Icon(
                                            Icons.phone,
                                            color: Colors.green,
                                          )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Fullname:      ",
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC)),
                                        ),
                                        Text(
                                          "${snapshot.data!.docs[0]['fullname']}",
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Id Number:     ",
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC)),
                                        ),
                                        Text(
                                          "${snapshot.data!.docs[0]['id']}",
                                          style: TextStyle(
                                              color: Color(0xffCCCCCC),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : SizedBox();
                        })
                    : SizedBox(),
              ],
            )),
        widget.dropOffTime == ""
            ? InkWell(
                child: GradientButton("Recieved Car"),
                onTap: () {
                  FirebaseAuthClass().changeProgress(DateTime.now().toString(),
                      "dropOffTime", widget.uid, context);

                  Get.off(AddReview());
                  FirebaseMessaging.instance.getToken().then((value) {
                    NotificationClass().sendPushNotificationToSeller(
                        "Thank you for using Barcade car wash",
                        value.toString());

                    NotificationClass().sendPushNotificationToSeller(
                        "${FirebaseAuth.instance.currentUser!.email} has received their car from rider at ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-${DateTime.now().hour}:${DateTime.now().minute}",
                        widget.assignedRider.toString());
                  });
                },
              )
            : SizedBox(),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: RadiantGradientMask(
                child: Text(
                  "Awaiting vendor acceptance request. ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 3,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34c6ad)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            widget.acceptanceTime != ""
                ? RadiantGradientMask(
                    child: text_widget(
                      color: 0xffFFFFFF,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      font: "Lato",
                      fontSize: 14,
                      text:
                          "Request accepted and a rider coming to pick it up. ",
                    ),
                  )
                : text_widget(
                    color: 0xffFFFFFF,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    font: "Lato",
                    fontSize: 14,
                    text: "Request accepted and a rider coming to pick it up. ",
                  ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 3,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34c6ad)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            widget.pickupTime != ""
                ? RadiantGradientMask(
                    child: text_widget(
                      color: 0xffFFFFFF,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      font: "Lato",
                      fontSize: 14,
                      text: "Rider picked up your car. ",
                    ),
                  )
                : text_widget(
                    color: 0xffFFFFFF,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    font: "Lato",
                    fontSize: 14,
                    text: "Rider picked up your car. ",
                  ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 3,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34c6ad)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            widget.servicedTime != ""
                ? RadiantGradientMask(
                    child: text_widget(
                      color: 0xffFFFFFF,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      font: "Lato",
                      fontSize: 14,
                      text: "Your car has arrived and waiting to be serviced ",
                    ),
                  )
                : text_widget(
                    color: 0xffFFFFFF,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    font: "Lato",
                    fontSize: 14,
                    text: "Your car has arrived and waiting to be serviced ",
                  ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 3,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34c6ad)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            widget.servicedTime != ""
                ? RadiantGradientMask(
                    child: text_widget(
                      color: 0xffFFFFFF,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      font: "Lato",
                      fontSize: 14,
                      text: "Your car is be serviced ",
                    ),
                  )
                : text_widget(
                    color: 0xffFFFFFF,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    font: "Lato",
                    fontSize: 14,
                    text: "Your car is be serviced ",
                  ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 3,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff34c6ad)),
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 15,
              color: Colors.greenAccent.withOpacity(0.4),
            ),
            const SizedBox(
              width: 8,
            ),
            widget.completionTime != ""
                ? RadiantGradientMask(
                    child: text_widget(
                      color: 0xffFFFFFF,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.center,
                      font: "Lato",
                      fontSize: 14,
                      text: "Your car is ready and awaiting next action",
                    ),
                  )
                : text_widget(
                    color: 0xffFFFFFF,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                    font: "Lato",
                    fontSize: 14,
                    text: "Your car is ready and awaiting next action",
                  ),
          ],
        ),
      ],
    );
  }

  //make a phone call....
  void makeCall(String number) async {
    // set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
