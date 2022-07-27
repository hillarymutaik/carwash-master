import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/screens/Drawer/addLocation/addLocation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';

class MyAddresses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return FadedSlideAnimation(
      Scaffold(
        appBar: appBar(context, locale.myAddresses!),
        body: Container(
          margin: EdgeInsets.all(15),
          // height: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(locale.savedAddresses!,
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("usersAddress")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.connectionState !=
                                  ConnectionState.waiting &&
                              snapshot.data!.docs.isNotEmpty
                          ? ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                List icons = [
                                  Assets.ic_home,
                                  Assets.ic_office,
                                  Assets.ic_other_location
                                ];
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    // horizontalTitleGap: 30,
                                    tileColor:
                                        Theme.of(context).backgroundColor,
                                    leading: FadedScaleAnimation(
                                      Image(
                                          height: 50,
                                          image: snapshot.data!.docs[index]
                                                      ['typeOfAddress'] ==
                                                  "home"
                                              ? AssetImage(
                                                  icons[0],
                                                )
                                              : snapshot.data!.docs[index]
                                                          ['typeOfAddress'] ==
                                                      "office"
                                                  ? AssetImage(
                                                      icons[1],
                                                    )
                                                  : AssetImage(
                                                      icons[2],
                                                    )),
                                      durationInMilliseconds: 400,
                                    ),
                                    contentPadding: EdgeInsets.all(15),
                                    title: Text(
                                        snapshot.data!.docs[index]['location'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(fontSize: 15)),
                                  ),
                                );
                              },
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text("No Address added yet"),
                                  ),
                                ),
                              ],
                            );
                    }),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddLocation()));
                  },
                  child: GradientButton(locale.addNewLocation))
            ],
          ),
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
