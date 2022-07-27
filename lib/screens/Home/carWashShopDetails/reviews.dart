import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Reviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      // physics: ScrollPhysics(),
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("ratingAndReviews")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        return snapshot.connectionState !=
                                    ConnectionState.waiting &&
                                snapshot.data!.docs.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection("userDetails")
                                                    .where("uid",
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<QuerySnapshot>
                                                        snapshots) {
                                                  return snapshots.connectionState !=
                                                              ConnectionState
                                                                  .waiting &&
                                                          snapshots.data!.docs
                                                              .isNotEmpty
                                                      ? Row(
                                                          children: [
                                                            FadedScaleAnimation(
                                                              CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage:
                                                                    NetworkImage(snapshots
                                                                            .data!
                                                                            .docs[0]
                                                                        [
                                                                        'imageUrl']),
                                                              ),
                                                              durationInMilliseconds:
                                                                  400,
                                                            ),
                                                            SizedBox(
                                                              width: 15,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  snapshots
                                                                          .data!
                                                                          .docs[0]
                                                                      [
                                                                      'fullname'],
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText1!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              13),
                                                                ),
                                                                Text(
                                                                  "${DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[index]['time'])}",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyText2!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              10),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox();
                                                }),
                                            SmoothStarRating(
                                                allowHalfRating: true,
                                                onRated: (rating) {},
                                                starCount: 5,
                                                rating: double.parse(snapshot
                                                    .data!
                                                    .docs[index]['ratingValue']
                                                    .toString()),
                                                size: 15.0,
                                                isReadOnly: true,
                                                color: Colors.amber,
                                                borderColor: Colors.amber,
                                                spacing: 0.0),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['msg'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  fontSize: 12,
                                                  color: Colors.grey[300]),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  );
                                },
                              )
                            : SizedBox();
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
