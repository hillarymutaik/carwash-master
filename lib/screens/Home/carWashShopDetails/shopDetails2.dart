import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/screens/Home/carWashShopDetails/about.dart';
import 'package:carwash/screens/Home/carWashShopDetails/reviews.dart';
import 'package:carwash/screens/Home/carWashShopDetails/services.dart';
import 'package:flutter/material.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/language/locale.dart';
import 'package:carwash/style/colors.dart';

double iconSize = 20;

class CarWashDetails2 extends StatefulWidget {
  final String carType, carDetails;

  const CarWashDetails2(
      {Key? key, required this.carType, required this.carDetails})
      : super(key: key);
  @override
  _CarWashDetails2State createState() => _CarWashDetails2State();
}

class _CarWashDetails2State extends State<CarWashDetails2>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  var _scrollController, _tabController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        NestedScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                pinned: true,
                expandedHeight: 300,
                leading: IconButton(
                    icon: Icon(
                      Icons.keyboard_backspace,
                      size: 24,
                      color: iconFgColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.favorite,
                        size: iconSize,
                        color: iconFgColor,
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.navigation,
                        size: iconSize,
                      ),
                      onPressed: () {}),
                  IconButton(
                      icon: Icon(
                        Icons.call,
                        size: iconSize,
                      ),
                      onPressed: () {})
                ],
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            color: Theme.of(context).backgroundColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  locale!.dummyStore1!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 22),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  locale.dummyAddress1!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            width: 45,
                            padding: EdgeInsets.symmetric(
                                horizontal: 7, vertical: 5),
                            decoration: BoxDecoration(gradient: gradient),
                            child: Row(
                              children: [
                                Text(
                                  locale.dummyRating!,
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(Icons.star, size: 10, color: Colors.white)
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        color: Theme.of(context).primaryColor,
                        child: TabBar(
                            onTap: (value) {
                              setState(() {
                                currentIndex = value;
                              });
                            },
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 45),
                            controller: _tabController,
                            tabs: [
                              Tab(
                                child: currentIndex == 0
                                    ? RadiantGradientMask(
                                        child: Text(locale.services!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                  fontSize: 18,
                                                )),
                                      )
                                    : Text(locale.services!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.white)),
                              ),
                              Tab(
                                child: currentIndex == 1
                                    ? RadiantGradientMask(
                                        child: Text(locale.about!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(
                                                    fontSize: 18,
                                                    color: Colors.white)),
                                      )
                                    : Text(locale.about!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.white)),
                              ),
                              Tab(
                                child: currentIndex == 2
                                    ? RadiantGradientMask(
                                        child: Text(locale.reviews!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .copyWith(fontSize: 18)),
                                      )
                                    : Text(locale.reviews!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 18,
                                                color: Colors.white)),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    foregroundDecoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Theme.of(context).backgroundColor,
                      Colors.transparent,
                    ], begin: Alignment.topCenter, end: Alignment.center)),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.layer_4),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Services(carType: widget.carType, carDetails: widget.carDetails),
              About(),
              Reviews()
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
