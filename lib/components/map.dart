import 'dart:async';

import 'package:carwash/OrderMapBloc/order_map_bloc.dart';
import 'package:carwash/OrderMapBloc/order_map_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../map_utils.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderMapBloc>(
      create: (context) => OrderMapBloc()..loadMap(),
      child: MapBody(),
    );
  }
}

class MapBody extends StatefulWidget {
  const MapBody({Key? key}) : super(key: key);

  @override
  _MapBodyState createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? mapStyleController;
  Set<Marker> _markers = {};

  Location location = Location();
  LocationData? _locationData;
  CameraPosition? kGooglePlex;

  void getCurrentLocation() async {
    _locationData = await location.getLocation();
    if (_locationData != null) {
      setState(() {
        kGooglePlex = CameraPosition(
          target: LatLng(_locationData!.latitude, _locationData!.longitude),
          zoom: 14.4746,
        );
      });
    }
    print("-----$_locationData-------");
  }

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderMapBloc, OrderMapState>(builder: (context, state) {
      print('polyyyy' + state.polylines.toString());
      return kGooglePlex != null
          ? GoogleMap(
              // polylines: state.polylines,
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex!,
              myLocationEnabled: true,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) async {
                _mapController.complete(controller);
                mapStyleController = controller;
                mapStyleController!.setMapStyle(mapStyle);
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId('mark1'),
                      position: LatLng(-1.2930863532860628, 36.79140266891122),
                      icon: markerss.first,
                    ),
                  );
                  _markers.add(
                    Marker(
                      markerId: MarkerId('mark2'),
                      position: LatLng(-1.2829656887559386, 36.785248711672075),
                      icon: markerss.first,
                    ),
                  );
                  _markers.add(
                    Marker(
                      markerId: MarkerId('mark3'),
                      position: LatLng(-1.2887792390114863, 36.79453773845632),
                      icon: markerss.first,
                    ),
                  );
                });
              },
            )
          : Center(child: SizedBox(child: CircularProgressIndicator(backgroundColor: Colors.white,),width: 40,height: 40,));
    });
  }
}
