import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Home/addReview/addReview.dart';
import 'package:carwash/screens/Home/booking/bookingDetails.dart';
import 'package:carwash/screens/Home/storeBanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';

import '../../../widget/view_booking.dart';

class MyBookings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: appBar(context, locale.myBookings!),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("bookings")
                .where("ownerID",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid).orderBy("requestedTime",descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        List icons = [
                          Assets.ic_home,
                          Assets.ic_office,
                          Assets.ic_other_location
                        ];

                        return InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewBooking(
                                      id: snapshot.data!.docs[index]['uid']))),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Assets.card_bg),
                                  fit: BoxFit.cover),
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  title: RadiantGradientMask(
                                    child: Text(
                                        snapshot.data!.docs[index]
                                            ['serviceType'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(fontSize: 18)),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          snapshot.data!.docs[index]
                                            ['pickupLocation']!=null?snapshot.data!.docs[index]
                                            ['pickupLocation']:"Loading...",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .copyWith(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(locale.bookingFor!),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              snapshot.data!.docs[index]
                                                  ['carSelection'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 13))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(locale.datetime!),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                              "${DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index]['requestedTime'])}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .copyWith(fontSize: 13))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(locale.bookingFor!),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: 20,
                                      // ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Column(
                    children: [
                      Center(
                        child: SizedBox(
                          child: Text("No booking done yet!"),
                        ),
                      ),
                    ],
                  );
            }));
  }
}
