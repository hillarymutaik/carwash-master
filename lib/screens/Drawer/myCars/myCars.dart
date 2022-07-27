import 'dart:developer';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Home/addCar/addCar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:get/get.dart';

import '../../Home/carWashShopDetails/services.dart';

class MyCars extends StatefulWidget {
  @override
  _MyCarsState createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff29ee86),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCar()));
        },
        child: FadedScaleAnimation(
          Icon(
            Icons.add,
            size: 35,
          ),
          durationInMilliseconds: 400,
        ),
      ),
      appBar: appBar(context, locale.myCars!),
      body: FadedSlideAnimation(
        StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("usersCars")
                .where("ownerID",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 75),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Container(
                            color: Theme.of(context).backgroundColor,
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(
                                  snapshot.data!.docs[index]['imgUrl'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                          "${snapshot.data!.docs[index]['carBrand']} ${snapshot.data!.docs[index]['carModel']}")),
                                  Text(
                                      "${snapshot.data!.docs[index]['carNoPlate']}"),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          child: Text("No car added yet"),
                        ),
                      ),
                    ],
                  );
            }),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
