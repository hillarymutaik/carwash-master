import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

class MyProfile extends StatelessWidget {
  // final ImagePicker _picker = ImagePicker();
  File? image;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var safeHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar(context, locale.profile!),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: safeHeight,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            // color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("userDetails")
                            .where("uid",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          return snapshot.connectionState !=
                                      ConnectionState.waiting &&
                                  snapshot.data!.docs.isNotEmpty
                              ? Column(
                                  children: [
                                    FadedScaleAnimation(
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.network(
                                          snapshot.data!.docs[0]['imageUrl'],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      durationInMilliseconds: 400,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              : SizedBox();
                        }),
                    InkWell(
                      onTap: () => imagePicker(),
                      child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: gradient),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("userDetails")
                        .where("uid",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return snapshot.connectionState !=
                                  ConnectionState.waiting &&
                              snapshot.data!.docs.isNotEmpty
                          ? Column(
                              children: [
                                EntryField(locale.fullName,
                                    snapshot.data!.docs[0]['fullname'], false),
                                SizedBox(
                                  height: 10,
                                ),
                                EntryField(
                                    locale.emailAddress,
                                    "${FirebaseAuth.instance.currentUser!.email}",
                                    false),
                                SizedBox(
                                  height: 10,
                                ),
                                EntryField(
                                    locale.phoneNumber,
                                    snapshot.data!.docs[0]['phoneNumber'],
                                    false),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : SizedBox();
                    }),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void imagePicker() async {
    // XFile? Image = await _picker.pickImage(source: ImageSource.gallery);
    // image = File(Image!.path);
    // FirebaseAuthClass().changeImages(image!, () {
    //   //successFunction
    //   Get.snackbar("Profile Details", "Image has been changed successful");
    // }, () {
    //   //failedFunction
    //   Get.snackbar("Profile Details", "Failed to changed image successfully");
    // }, () {
    //   //imageAdded
    // });
  }
}
