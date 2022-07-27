import 'dart:math';

import 'package:carwash/screens/Home/booking/bookingDetails.dart';
import 'package:carwash/screens/Home/carWashShopDetails/when.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:get/get.dart';

import '../../../components/constants.dart';

class Services extends StatefulWidget {
  final String carType,carDetails;

  const Services({Key? key, required this.carType, required this.carDetails}) : super(key: key);
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List checked = [];
  double finalPrice = 0.0;
  List selectedList = [];
  List checkList = [];

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("services")
                  // .where("carType", isEqualTo: widget.carType)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                return snapshot.connectionState != ConnectionState.waiting &&
                        snapshot.data!.docs.isNotEmpty
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 75),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.connectionState !=
                                      ConnectionState.waiting &&
                                  snapshot.data!.docs.isNotEmpty
                              ? Container(
                                  color: Theme.of(context).backgroundColor,
                                  child: CheckboxListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    activeColor: Color(0xff29ee86),
                                    onChanged: (value) {
                                      setState(() {
                                        setState(() {
                                          if (checkList.contains(snapshot
                                              .data!.docs[index]['serviceName']
                                              .toString())) {
                                            checkList.remove(snapshot.data!
                                                .docs[index]['serviceName']);
                                            selectedList
                                                .removeAt(checkList.length);
                                            print(" ----$checkList");
                                            if (finalPrice != 0) {
                                              finalPrice = finalPrice -
                                                  double.parse(snapshot
                                                      .data!
                                                      .docs[index]
                                                          ['servicePrice']
                                                      .toString());
                                            }
                                          } else {
                                            checkList.add(snapshot.data!
                                                .docs[index]['serviceName']);
                                            selectedList.add({
                                              "name": snapshot.data!.docs[index]
                                                  ['serviceName'],
                                              "price": snapshot.data!
                                                  .docs[index]['servicePrice']
                                            });
                                            print(" ----$checkList");
                                            finalPrice = finalPrice +
                                                double.parse(snapshot.data!
                                                    .docs[index]['servicePrice']
                                                    .toString());
                                          }
                                        });
                                      });
                                    },
                                    checkColor:
                                        Theme.of(context).backgroundColor,
                                    value: checkList.contains(snapshot
                                        .data!.docs[index]['serviceName']),
                                    secondary: checkList.contains(snapshot
                                            .data!.docs[index]['serviceName'])
                                        ? HomePageIcons(
                                            Icons.drive_eta, 25.0, 12.0)
                                        : SimpleHomePageIcons(
                                            Icons.drive_eta, 25.0, 12.0),
                                    subtitle: Text(
                                      "${snapshot.data!.docs[index]['description']}",
                                      style: TextStyle(
                                          color: Color(0xffF1F1F1),
                                          fontSize: 12),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(snapshot.data!
                                                .docs[index]['serviceName'])),
                                        Text(
                                            "Ksh ${snapshot.data!.docs[index]['servicePrice']}"),
                                      ],
                                    ),
                                  ),
                                )
                              : SizedBox();
                        },
                      )
                    : SizedBox();
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                if (selectedList.isNotEmpty) {
                  Get.off(WhenPage(finalPrice: finalPrice, services: selectedList,carDetails:widget.carDetails));
                } else {}
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                decoration: BoxDecoration(gradient: gradient),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Ksh $finalPrice",
                      style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                    ),

                    Text(
                      "Next",
                      style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
