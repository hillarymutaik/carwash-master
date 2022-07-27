import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/map.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchServiceLocation extends StatefulWidget {
  @override
  _SearchServiceLocationState createState() => _SearchServiceLocationState();
}

class _SearchServiceLocationState extends State<SearchServiceLocation> {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            }),
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          locale.cancel!,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
              fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1),
        ),
      ),
      body: Stack(children: [
        // Container(
        //   decoration: BoxDecoration(
        //       image: DecorationImage(
        //           image: AssetImage(Assets.map), fit: BoxFit.cover)),
        // ),
        MapPage(),
        SingleChildScrollView(
          child: Container(
            height: 300,
            color: Theme.of(context).backgroundColor,
            child: Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          hintText: locale.searchLocation,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 15),
                          suffixIcon: Icon(
                            Icons.gps_fixed,
                            color: Colors.grey,
                          ))),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("usersAddress")
                        .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.data!.docs.isNotEmpty
                  ?  ListView.builder(
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
                              tileColor: Theme.of(context).backgroundColor,
                              leading: FadedScaleAnimation(
                                Image(
                                    height: 50,
                                    image: snapshot.data!.docs[index]['typeOfAddress']=="home"? AssetImage(
                                      icons[0],
                                    ):snapshot.data!.docs[index]['typeOfAddress']=="office"? AssetImage(
                                      icons[1],
                                    ):AssetImage(
                                      icons[2],
                                    )),
                                durationInMilliseconds: 400,
                              ),
                              contentPadding: EdgeInsets.all(15),
                              title: Text(snapshot.data!.docs[index]['location'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontSize: 15)),
                            ),
                          );
                        },
                      ): Center(child: CircularProgressIndicator());
                    }),
              
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
