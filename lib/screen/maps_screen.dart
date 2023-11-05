import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({
    super.key,
  });

  @override
  State<MapsScreen> createState() {
    return _MapsScreenState();
  }
}

class _MapsScreenState extends State<MapsScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      compassEnabled: true,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(48.16421861543514, 11.60562981499409),
        zoom: 16,
      ),
    );
  }
}
