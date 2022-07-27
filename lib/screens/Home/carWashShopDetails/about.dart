import 'package:carwash/components/map.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Stack(
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage(Assets.map), fit: BoxFit.cover)),
          // ),
          MapPage(),
          Container(
            height: 260,
            color: Theme.of(context).backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(locale.openingHours!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(fontSize: 15)),
                          ),
                          Row(
                            children: [
                              Text(locale.openNow!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 15,
                                        color: Color(0xff29ee86),
                                      )),
                              Text(locale.dummyOpeningTime!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(fontSize: 15))
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(locale.about!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15)),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        locale.lorem!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(locale.address!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15)),
                          // Text(locale.getDirection!,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .bodyText1!
                          //         .copyWith(
                          //           fontSize: 15,
                          //           color: Color(0xff29ee86),
                          //         ))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(locale.dummyAddress1!),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
