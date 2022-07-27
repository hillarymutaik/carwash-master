import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/assets/assets.dart';
import 'package:carwash/components/constants.dart';
import 'package:carwash/screens/Drawer/drawer.dart';
import 'package:carwash/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    var locale = AppLocalizations.of(context)!;
    return FadedSlideAnimation(
      Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
              icon: Icon(
                Icons.menu,
                color: iconFgColor,
              ),
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              }),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            locale.favourites!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 1),
          ),
        ),
        drawer: MyDrawer(),
        body: Container(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 10),
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.symmetric(vertical: 3),
                    child: ListTile(
                      leading: FadedScaleAnimation(
                        CircleAvatar(
                          backgroundImage: AssetImage(Assets.layer_4),
                        ),
                        durationInMilliseconds: 400,
                      ),
                      title: Text(locale.dummyStore1!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 17)),
                      subtitle: Text(locale.dummyAddress1!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 13)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Color(0xff29ee86),
                          size: 18,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(gradient: gradient),
                          child: Row(
                            children: [
                              Text(
                                locale.dummyRating!,
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(Icons.star, size: 15, color: Colors.white)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
      beginOffset: Offset(0, 0.3),
      endOffset: Offset(0, 0),
      slideCurve: Curves.linearToEaseOut,
    );
  }
}
