import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/i18n.dart';
import '../utils/services/location_service.dart';
import '../utils/utils.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/map';
  const MapScreen({
    super.key,
    this.editLocationAllowed = false,
    this.initialLocData,
    this.title = 'Pick Location',
  });
  final bool editLocationAllowed;
  final Map<String, double>? initialLocData;
  final String title;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final i18n i;
  LatLng? _pickedLocLatLng;
  final Completer<GoogleMapController> _controller =
      Completer(); // import 'dart:async';

  @override
  void initState() {
    super.initState();
    i = Provider.of<i18n>(context, listen: false);

    _pickedLocLatLng = widget.initialLocData == null
        ? kErbilLatLng
        : LatLng(
            widget.initialLocData!['lat']!, widget.initialLocData!['long']!);
  }

  @override
  Widget build(BuildContext context) {
    print('*************** map_screen build ***************');
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GoogleMap(
        /// if you want to use "google_maps_flutter" build in get current functionality WITHOUT using "location" package, uncomment the following
        /// AND comment out "_controller", "import 'dart:async'", "onMapCreated", "floatingActionButton", "_getCurrentLocation", and in location_service.dart "getLocation()"
        // // myLocationButtonEnabled: true, // default and it is mandatory to "myLocationEnabled"
        // myLocationEnabled: true,
        // onCameraMove: (cp) {
        //   if (widget.editLocationAllowed) {
        //     setState(() => _pickedLocLatLng = cp.target);
        //   }
        // },
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: _pickedLocLatLng!, zoom: 10),
        onTap: widget.editLocationAllowed ? _selectLocation : null,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          // this function need to attach "_controller" which is defined "_MapScreenState" in  to the map
        },
        markers: {
          Marker(markerId: const MarkerId('m1'), position: _pickedLocLatLng!)
        },
      ),
      floatingActionButton: widget.editLocationAllowed
          ? Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.small(
                onPressed: _getCurrentLocation,
                tooltip: 'Your current location',
                backgroundColor: Colors.black,
                child: const Icon(Icons.location_searching),
              ),
            )
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext ctx) {
    return AppBar(
      // leading: IconButton(
      //   icon: const Icon(Icons.close, color: Colors.black),
      //   onPressed: () => Navigator.of(context).pop(),
      // ),
      iconTheme: const IconThemeData(
        color: Colors.black, //change leading icon color
      ),
      title:
          Text(i.tr(widget.title), style: const TextStyle(color: Colors.black)),
      actions: <Widget>[
        if (widget.editLocationAllowed)
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _pickedLocLatLng == null
                ? null
                : () {
                    Navigator.of(ctx).pop({
                      'lat': _pickedLocLatLng!.latitude,
                      'long': _pickedLocLatLng!.longitude
                    });
                  },
          ),
      ],
      backgroundColor: const Color(0xffF3F2F8),
      centerTitle: true,
      elevation: 0,
    );
  }

  void _selectLocation(LatLng position) {
    setState(() => _pickedLocLatLng = position);
  }

  Future<void> _getCurrentLocation() async {
    try {
      final currentLocation = await LocationService.getLocation();
      final GoogleMapController controller = await _controller.future;
      _pickedLocLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      final CameraPosition newCameraPosition =
          CameraPosition(target: _pickedLocLatLng!, zoom: 14.4746);
      controller
          .animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
      setState(() {}); // to show marker in new position
    } catch (e) {
      Utils.showErrorDialog(context, e.toString());
    }
  }
}
