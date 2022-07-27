import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../assets/assets.dart';
import '../language/locale.dart';

class LocationClass extends StatefulWidget {
  final double lat, long;

  const LocationClass({Key? key, required this.lat, required this.long})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _locationClassState();
  }
}

class _locationClassState extends State<LocationClass> {
  var placemarks;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   locale.serviceLocation!,
        //   textAlign: TextAlign.start,
        //   style: Theme.of(context).textTheme.bodyText1,
        // ),
        // Row(
        //   children: [
        //     Icon(
        //       Icons.gps_fixed,
        //       color: Colors.grey[800],
        //       size: 14,
        //     ),
        //     Text(
        //       "$placemarks",
        //       overflow: TextOverflow.clip,
        //       style:
        //           Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11),
        //     ),
        //   ],
        // ),
        Image.asset(Assets.logo,width: 160),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationText();
  }

  //get current location address
  void getLocationText() async {
    placemarks = await placemarkFromCoordinates(widget.lat, widget.long);
  }
}
