import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  OverlayState? _overlay;
  OverlayEntry? _currentEntry;
  late Size _screenSize;

  final _markers = [
    FriendMarker(latlng: LatLng(51.513394, -0.089315)),
    FriendMarker(latlng: LatLng(51.495264, -0.100301))
  ];

  @override
  void didChangeDependencies() {
    _screenSize = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onTap: (position, latlng) {
            _hideMarkerDetails();
          },
          center: LatLng(51.5, -0.09),
          zoom: 13.0,
        ),
        children: <Widget>[
          TileLayerWidget(
              options: TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'])),
        ],
        layers: [
          MarkerLayerOptions(
            markers: _markers
                .map((marker) => Marker(
                      point: marker.latlng,
                      builder: (ctx) => InkWell(
                        onTap: () {
                          _showMarkersDetail();
                        },
                        child: Container(
                          width: 15,
                          height: 50,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  void _showMarkersDetail() {
    _currentEntry?.remove();
    _overlay ??= Overlay.of(context);
    _currentEntry = OverlayEntry(
        builder: (context) => Positioned(
            bottom: 20,
            left: _screenSize.width * 0.05,
            child: Container(
              width: _screenSize.width * 0.9,
              height: 100,
              color: Colors.white,
            )));
    _overlay!.insert(_currentEntry!);
  }

  void _hideMarkerDetails() {
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class FriendMarker {
  final dynamic metadata;
  final LatLng latlng;

  FriendMarker({required this.latlng, this.metadata});
}
