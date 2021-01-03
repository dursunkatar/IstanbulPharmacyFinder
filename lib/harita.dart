import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Harita extends StatefulWidget {
  double _lat;
  double _lon;

  @override
  _HaritaState createState() => _HaritaState();

  Harita(this._lat, this._lon);
}

class _HaritaState extends State<Harita> {
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  CameraPosition _position;

  @override
  void initState() {
    super.initState();
    debugPrint(widget._lat.toString());
    _position = CameraPosition(
      target: LatLng(widget._lat, widget._lon),
      zoom: 17.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        markers: Set<Marker>.of(_markers.values),
        initialCameraPosition: _position,
        onMapCreated: (GoogleMapController controller) {
          final MarkerId _markerId = MarkerId('merkez');
          final Marker _marker = Marker(
            markerId: _markerId,
            position: LatLng(widget._lat, widget._lon),
          );
          setState(() {
            _markers[_markerId] = _marker;
          });
        },
      ),
    );
  }
}
