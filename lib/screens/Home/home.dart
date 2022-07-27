import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/backend/notification.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/components/map.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/screens/Drawer/drawer.dart';
import 'package:carwash/screens/Home/addCar/addCar.dart';
import 'package:carwash/screens/Home/carWashShopDetails/shopDetails2.dart';
import 'package:carwash/screens/Home/serviceLocation/serviceLocation.dart';
import 'package:carwash/screens/Home/storeBanner.dart';
import 'package:carwash/style/colors.dart';
import 'package:carwash/widget/location_pg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

import 'booking/bookingDetails2.dart';
import 'carWashShopDetails/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List time = [
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "01:00",
    "02:00",
    "03:00",
    "04:00",
    "05:00",
    "06:00"
  ];
  String? car = "";
  String? service = "";
  String whenDate = "";
  String? whenTime = "";
  bool selectCar = false;
  bool selectServices = false;
  bool selectWhen = false;
  bool selectLocation = false;
  bool markerSelected = false;
  List locationList = [];
  int? group;
  int currentIndex = -1;
  int currentDateIndex = -1;
  int currentTimeIndex = -1;
  Location location = Location();
  LocationData? _locationData;
  double lat = 0.0;
  String? typeCar;
  double long = 0.0;

  void getCurrentLocation() async {
    _locationData = await location.getLocation();
    if (_locationData != null) {
      setState(() {
        lat = _locationData!.latitude;
        long = _locationData!.longitude;
      });
    }
    print("-----$_locationData-------");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentLocation();
  }

  Color iconColor = Color(0xff29ee86);

  carsListView(BuildContext context, var height) {
    var locale = AppLocalizations.of(context)!;
    List images = [Assets.car_1, Assets.car_2];
    List cars = [locale.car1, locale.car2];
    List numbers = [locale.car1Number, locale.car2Number];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
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
                  ? Column(
                      children: [
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: FadedScaleAnimation(
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]['imgUrl']),
                                ),
                                durationInMilliseconds: 400,
                              ),
                              title: Text(
                                  "${snapshot.data!.docs[index]['carBrand']}, ${snapshot.data!.docs[index]['carModel']}",
                                  style: Theme.of(context).textTheme.bodyText1),
                              subtitle: Text(
                                  "${snapshot.data!.docs[index]['carNoPlate']}",
                                  style: Theme.of(context).textTheme.bodyText2),
                              trailing: Radio(
                                activeColor: Color(0xff29ee86),
                                value: index,
                                groupValue: group,
                                onChanged: (dynamic val) {
                                  setState(() {
                                    group = val;
                                    car = cars[val];
                                    typeCar =
                                        snapshot.data!.docs[index]['carType'];
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: GradientButton("Next"),
                          onTap: () {
                            setState(() {
                              selectCar = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CarWashDetails2(
                                        carType: typeCar!, carDetails: car!)));
                          },
                        )
                      ],
                    )
                  : SizedBox();
            }),
        ListTile(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddCar()));
          },
          contentPadding: EdgeInsets.only(right: 12),
          leading: FadedScaleAnimation(
            CircleAvatar(
              backgroundColor: iconBgColor,
              radius: 25,
              child: Icon(Icons.add),
            ),
            durationInMilliseconds: 400,
          ),
          title: Text(locale.addNewCar!,
              style: Theme.of(context).textTheme.bodyText1),
          subtitle: Text(locale.tapToAdd!,
              style: Theme.of(context).textTheme.bodyText2),
          trailing: Icon(
            Icons.add,
            color: Theme.of(context).unselectedWidgetColor,
          ),
        ),
      ],
    );
  }

  servicesGridView(BuildContext context, var height) {
    var locale = AppLocalizations.of(context)!;
    List services = [
      locale.bodywash,
      locale.interiorCleaning,
      locale.engineDetailing,
      locale.carPolish
    ];
    List icons = [
      Icons.drive_eta,
      Icons.accessible,
      Icons.calendar_view_day,
      Icons.wb_sunny
    ];
    return Container(
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              icon: Icon(
                Icons.arrow_drop_down_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  selectServices = false;
                });
              }),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("services")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return snapshot.connectionState != ConnectionState.waiting &&
                          snapshot.data!.docs.isNotEmpty
                      ? GridView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 45,
                                  childAspectRatio: 0.75),
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                        service = services[index];
                                      });
                                    },
                                    child: currentIndex == index
                                        ? FadedScaleAnimation(
                                            HomePageIcons(
                                                icons[index], 35.0, 17.5),
                                            durationInMilliseconds: 400,
                                          )
                                        : FadedScaleAnimation(
                                            CircleAvatar(
                                              backgroundColor: iconBgColor,
                                              child: Icon(icons[0],
                                                  size: 35,
                                                  color: Colors.white),
                                              radius: 35,
                                            ),
                                            durationInMilliseconds: 400,
                                          ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['serviceName'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                      locale.approx! +
                                          " Ksh ${snapshot.data!.docs[index]['servicePrice']}",
                                      style:
                                          Theme.of(context).textTheme.bodyText2)
                                ],
                              ),
                            );
                          },
                        )
                      : SizedBox();
                }),
          ),
        ],
      ),
    );
  }

  selectDate(BuildContext context, var height) {
    var locale = AppLocalizations.of(context)!;
    List week = [
      locale.sun,
      locale.mon,
      locale.tue,
      locale.wed,
      locale.thr,
      locale.fri,
      locale.sat
    ];
    List months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return Container(
      height: height,
      child: FadedSlideAnimation(
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                icon: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    selectWhen = false;
                  });
                }),
            Text(locale.selectDateAndTime!,
                style: Theme.of(context).textTheme.bodyText1),
            SizedBox(
              height: 13,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: 31,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Text(months[DateTime.now().month],
                            style: currentDateIndex == index
                                ? Theme.of(context).textTheme.bodyText1
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(fontSize: 15)),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentDateIndex = index;
                              whenDate = (index + 1).toString() +
                                  " " +
                                  months[DateTime.now().month];
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            decoration: currentDateIndex == index
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(colors: [
                                      Color(0xff29ee86),
                                      Color(0xff3fa0d7)
                                    ]))
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: iconBgColor),
                            child: Text(
                              (index + 1).toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(week[index % 7])
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              currentTimeIndex = index;
                              if (!(whenDate == "")) {
                                whenTime = time[index] + " " + locale.am;
                              }
                              if (car != "" &&
                                  service != "" &&
                                  whenDate != "" &&
                                  whenTime != "") {
                                Get.defaultDialog(
                                    title: "Make a Booking",
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    titleStyle: TextStyle(color: Colors.white),
                                    middleText:
                                        "Your are about to make a booking. (Car mobel $car, Service $service, on the $whenDate at $whenTime. Are you sure?",
                                    actions: [
                                      GestureDetector(
                                        child: GradientButton("Book Now"),
                                        onTap: () {
                                          Get.back();
                                          getTheCarList();
                                          Get.to(BookingDetails2(
                                              true,
                                              locationList,
                                              200.0,
                                              service!,
                                              car!,
                                              whenDate,
                                              whenTime!));
                                        },
                                      ),
                                      GestureDetector(
                                        child: GradientButton("Cancel"),
                                        onTap: () {
                                          Get.back();
                                          setState(() {
                                            car = "";
                                            service = "";
                                            whenDate = "";
                                            whenTime = "";
                                          });
                                        },
                                      ),
                                    ]);
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 13),
                            decoration: currentTimeIndex == index
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: gradient)
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: iconBgColor),
                            child: Text(
                              time[index],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(locale.am!)
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  //variables
  var firebaseAuth = FirebaseAuth.instance;

  final fireStoreInstance = FirebaseFirestore.instance;

  FirebaseStorage storageReference = FirebaseStorage.instance;
  void getTheCarList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usersCars')
        .where("ownerID", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    QuerySnapshot snapshotLocation = await FirebaseFirestore.instance
        .collection('usersAddress')
        .where("uid", isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    snapshotLocation.docs.forEach((element) {
      if (locationList.contains(element['location'])) {
        locationList.remove(element['location']);
        locationList.add(element['location']);
      } else {
        locationList.add(element['location']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var safeHeight = MediaQuery.of(context).size.height -
        AppBar().preferredSize.height -
        MediaQuery.of(context).padding.vertical;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(child: MyDrawer()),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage(Assets.map), fit: BoxFit.cover)),
          // ),
          MapPage(),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            color: Theme.of(context).primaryColor,
            height: selectServices || selectWhen
                ? 520
                : selectCar
                    ? Get.height - 100
                    : 140,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                selectCar
                    ? carsListView(context, Get.height)
                    : SizedBox.shrink(),
                selectCar || selectServices || selectWhen
                    ? Divider(
                        height: 8,
                      )
                    : Container(
                        height: 8,
                      ),
                Spacer(),
                //
                // SizedBox(
                //   height: 20,
                // ),
                selectCar
                    ? Divider(
                        color: Colors.grey[800],
                      )
                    : SizedBox(),
                selectCar
                    ? InkWell(
                        child: GradientButton("Cancel"),
                        onTap: () {
                          setState(() {
                            selectCar = false;
                          });
                        },
                      )
                    : InkWell(
                        onTap: () {
                          if (selectCar == false) {
                            setState(() {
                              selectCar = true;
                            });
                          } else {
                            setState(() {
                              selectCar = false;
                            });
                          }
                        },
                        child: SizedBox(
                          child: GradientButton("Book Now"),
                          height: 60,
                        ),
                      ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My location",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.gps_fixed,
                              color: Colors.grey[800],
                              size: 14,
                            ),
                            Text(
                              locale.dummyAddress1!,
                              overflow: TextOverflow.clip,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchServiceLocation()));
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: safeHeight * 0.07,
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: iconFgColor,
                  ),
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                    // showDrawer = !showDrawer;
                  }),
            ),
          ),
          selectLocation
              ? Positioned(
                  top: 155,
                  left: 15,
                  child: FadedScaleAnimation(
                    Container(
                        height: 55,
                        child: Image(image: AssetImage(Assets.mark))),
                    durationInMilliseconds: 400,
                  ))
              : SizedBox.shrink(),
          selectLocation
              ? Positioned(
                  top: 85,
                  left: 200,
                  child: FadedScaleAnimation(
                    Container(
                        height: 55,
                        child: Image(image: AssetImage(Assets.mark))),
                    durationInMilliseconds: 400,
                  ))
              : SizedBox.shrink(),
          selectLocation
              ? Positioned(
                  top: 305,
                  left: 175,
                  child: FadedScaleAnimation(
                    Container(
                        height: 55,
                        child: Image(image: AssetImage(Assets.mark))),
                    durationInMilliseconds: 400,
                  ))
              : SizedBox.shrink(),
          selectLocation
              ? Positioned(
                  top: safeHeight * 0.4,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CarWashDetails2(
                                  carType: typeCar!, carDetails: car!)));
                    },
                    child: QuickWashServices(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}
