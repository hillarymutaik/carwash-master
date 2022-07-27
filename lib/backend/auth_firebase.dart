// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'notification.dart';
// import 'package:image_picker/image_picker.dart';

class FirebaseAuthClass {
  //variables
  var firebaseAuth = FirebaseAuth.instance;

  final fireStoreInstance = FirebaseFirestore.instance;
  FirebaseStorage storageReference = FirebaseStorage.instance;

  // 1: then login to access account
  Future<void> loginUserAsSeller(
      String email, String password, successFunction, failedFunction) async {
    firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      /*successFunction*/
      successFunction();
    }).onError((error, stackTrace) {
      failedFunction();
      print(error);
    });
  }

  // 2: Create an auth account to write on the backend
  Future<void> createUser(
      File images,
      String phoneNumber,
      String fullname,
      String country,
      String email,
      String password,
      successFunction,
      failedFunction,
      weekPassword,
      userFound) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
              email: email.toString().trim().replaceAll(" ", ""),
              password: password);
      if (userCredential.user != null) {
        uploadingImages(email, password, phoneNumber, fullname, country, images,
            successFunction, failedFunction, () {});
        successFunction();
      }
    } on FirebaseAuthException catch (e) {
      failedFunction();
      print("Firebase exception");
      print(e.toString());
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        weekPassword();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        userFound();
      }
    }
  }

  //save the user records to the backend...........
  Future<void> addTheUserDetails(String phoneNumber, String fullname,
      String country, String imageUrl, String uid, succesfull, failed) async {
    fireStoreInstance
        .collection("userDetails")
        .doc(uid)
        .set({
          "fullname": fullname,
          "phoneNumber": phoneNumber,
          "imageUrl": imageUrl,
          "uid": uid,
          "country": country,
          "registrationTimeStamp": DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => succesfull())
        .onError((error, stackTrace) => failed());
  }

  ///forgot password
  Future<void> forgotPassword(
      String email, successFunction, failedFunction) async {
    firebaseAuth
        .sendPasswordResetEmail(email: email)
        .then((value) => successFunction())
        .onError((error, stackTrace) {
      failedFunction();
      print("$error");
    });
  }

  Future<void> signOutAccount(successFunction, failedFunction) async {
    firebaseAuth
        .signOut()
        .then((value) => successFunction())
        .onError((error, stackTrace) => failedFunction());
  }

  void uploadingImages(
      String email,
      String password,
      String phoneNumber,
      String fullname,
      String country,
      File images,
      successFunction,
      failedFunction,
      imageAdded) async {
    /* DateTime.now().millisecondsSinceEpoch;*/
    try {
      firebase_storage.UploadTask uploadTask = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('/userprofileimg')
          .child('images${FirebaseAuth.instance.currentUser!.uid}')
          .putFile(images);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      // Once the image is uploaded to firebase get the download link.
      String imageFile = await snapshot.ref.getDownloadURL();
      if (imageFile.isNotEmpty) {
        loginUserAsSeller(email, password, () {
          //success
          addTheUserDetails(
              phoneNumber,
              fullname,
              country,
              imageFile,
              FirebaseAuth.instance.currentUser!.uid,
              () => successFunction(),
              () => failedFunction());
        }, failedFunction);
      }
    } catch (exception) {}
  }

  ///place a booking.......
  ///
  ///
  ///
  ///
  ///add a new car to the list.....
  ///
  ///
  void addCar(
    File images,
    String carBrand,
    String carModel,
    String carNoPlate,
    String carType,
    successFunction,
    failedFunction,
  ) async {
    String uid =
        "${firebaseAuth.currentUser!.uid}c-a-r${DateTime.now().millisecondsSinceEpoch}";
    firebase_storage.UploadTask uploadTask = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('/usercarimg')
        .child('car-images${DateTime.now().toString()}')
        .putFile(images);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    // Once the image is uploaded to firebase get the download link.
    String imageFile = await snapshot.ref.getDownloadURL();
    if (imageFile != null) {
      fireStoreInstance
          .collection("usersCars")
          .doc(uid)
          .set({
            "carBrand": carBrand,
            "carModel": carModel,
            "carNoPlate": carNoPlate,
            "imgUrl": imageFile,
            "carType": carType,
            "uid": uid,
            "ownerID": firebaseAuth.currentUser!.uid,
            "timeStamp": DateTime.now().millisecondsSinceEpoch
          })
          .then((value) => successFunction())
          .onError((error, stackTrace) => failedFunction());
    }
  }

  void changeImages(
      File images, successFunction, failedFunction, imageAdded) async {
    /* DateTime.now().millisecondsSinceEpoch;*/
    try {
      firebase_storage.UploadTask uploadTask = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('/userprofileimg')
          .child('images${firebaseAuth.currentUser!.uid}')
          .putFile(images);
      firebase_storage.TaskSnapshot snapshot = await uploadTask;
      // Once the image is uploaded to firebase get the download link.
      String imageFile = await snapshot.ref.getDownloadURL();
      if (imageFile.isNotEmpty) {
        fireStoreInstance
            .collection("userDetails")
            .doc(firebaseAuth.currentUser!.uid)
            .update({"imageUrl": imageFile});
      }
    } catch (exception) {}
  }

  //add booking...
  void bookingAdding(
      double finalPrice,
      String serviceType,
      String carSelection,
      bool pickUp,
      String dateTime,
      String pickupTime,
      List selected,
      successful,
      failed) async {
    var uid =
        "${firebaseAuth.currentUser!.uid}-booking- ${DateTime.now().millisecondsSinceEpoch}";
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('providerDeviceToken')
        .where("email", isEqualTo: "admin@baracade.com")
        .get();

    snapshot.docs.forEach((element) {
       FirebaseMessaging.instance.getToken().then((value) => fireStoreInstance
        .collection("bookings")
        .doc(uid)
        .set({
          "serviceType": serviceType,
          "carSelection": carSelection,
          "pickUp": pickUp,
          "requestedTime": DateTime.now().millisecondsSinceEpoch,
          "services": selected,
          "payableAmount": finalPrice,
          "dateTime": dateTime,
          "vendorAcceptiance": "",
          "pickUpTime": pickupTime,
          "serviceTime": "",
          "completionTime": "",
          "uid": uid,
          "done": "Ongoing",
          "rider": "",
          "dropOffTime": "",
          "ownerID": firebaseAuth.currentUser!.uid,
          "pickupLocation": "",
          "deviceToken": value,
          "assigner":element['deviceToken']
        })
        .then((value) => successful())
        .onError((error, stackTrace) {
          failed(error);
          print("-----this is an error msg : $error");
        }));
    });
  }

  ///adding home address...
  ///
  void addAddress(String location, var typeOfAddress, succesful, failed) {
    fireStoreInstance
        .collection('usersAddress')
        .doc()
        .set({
          "uid": firebaseAuth.currentUser!.uid,
          "typeOfAddress": typeOfAddress,
          "location": "Kenya Nairobi $location",
          "time": DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => succesful())
        .onError((error, stackTrace) => failed());
  }

  ///adding rating...
  ///
  void makeRating(String msg, double ratingValue, succesful, failed) {
    fireStoreInstance
        .collection('ratingAndReviews')
        .doc()
        .set({
          "uid": firebaseAuth.currentUser!.uid,
          "ratingValue": ratingValue,
          "msg": msg,
          "time": DateTime.now().millisecondsSinceEpoch
        })
        .then((value) => succesful())
        .onError((error, stackTrace) => failed());
  }

  //update the progress check...
  void changeProgress(
      String value, String fieldName, String uid, BuildContext context) {
    fireStoreInstance.collection("bookings").doc(uid).update(
        {fieldName: value, "completionTime": DateTime.now()}).then((value) {
      FirebaseMessaging.instance.getToken().then((value) {
        NotificationClass().sendPushNotificationToSeller(
            "Driver has received your car and on-route to the car wash.",
            value.toString());

        NotificationClass().sendPushNotificationToSeller(
            "${FirebaseAuth.instance.currentUser!.email} has released the car to rider at ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-${DateTime.now().hour}:${DateTime.now().minute}",
            value.toString());
      });
      Fluttertoast.showToast(
          msg: "Request Accepted.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).backgroundColor,
          textColor: Colors.white,
          fontSize: 14.0);
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(
          msg: "Failed to accept.Check your internet connection and try again.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).backgroundColor,
          textColor: Colors.white,
          fontSize: 14.0);
    });
  }
}
