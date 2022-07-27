import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:carwash/screens/Home/booking/bookingDetails2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../../../components/constants.dart';
import '../../../components/widgets.dart';
import '../../../language/locale.dart';
import '../../../style/colors.dart';
import '../booking/bookingDetails.dart';

class WhenPage extends StatefulWidget {
  final List services;
  final double finalPrice;
  final String carDetails;

  const WhenPage(
      {Key? key,
      required this.services,
      required this.finalPrice,
      required this.carDetails})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _whenPageState();
  }
}

class _whenPageState extends State<WhenPage> {
  bool pickLater = false;

  final formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    TextStyle whiteFont =
        Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 14);
    return Scaffold(
      appBar: appBar(context, "Time and Date"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectWhen != true
                ? Column(
                    children: [
                      InkWell(
                        child: GradientButton("Wash Now"),
                        onTap: () => Get.to(BookingDetails(
                            true,
                            widget.services,
                            widget.finalPrice,
                            widget.carDetails,
                            DateTime.now(),
                            "")),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "OR",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 17, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 10,
            ),
            selectWhen != true
                ? InkWell(
                    child: GradientButton("Wash Later"),
                    onTap: () => setState(() {
                      selectWhen != true
                          ? selectWhen = true
                          : selectWhen = false;
                    }),
                  )
                : SizedBox(),
            selectWhen != false ? selectDate(context, 450.0) : SizedBox(),
          ],
        ),
      ),
    );
  }

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

  int currentIndex = -1;
  int currentDateIndex = -1;
  int currentTimeIndex = -1;
  bool selectWhen = false;

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
                        Text(months[DateTime.now().month-1],
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
            whenDate != "" && whenTime != ""
                ? InkWell(
                    child: GradientButton("Next"),
                    onTap: () {
                      Get.to(BookingDetails(
                          true,
                          widget.services,
                          widget.finalPrice,
                          widget.carDetails,
                          whenDate,
                          whenTime!));
                      
                    },
                  )
                : SizedBox()
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
