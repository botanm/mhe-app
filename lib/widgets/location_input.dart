import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/i18n.dart';
import '../screens/map_screen.dart';
import 'circle_border_widget.dart';
import 'icon_widget.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    this.initialLocData,
    required this.onSetLocationHandler,
    this.editLocationAllowed = true,
    this.title = 'Pick Location',
    required this.isEnabled,
  });
  final Map<String, double>? initialLocData;
  final ValueChanged<Map<String, dynamic>> onSetLocationHandler;
  final bool editLocationAllowed;
  final String title;
  final bool isEnabled;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  late final i18n i;
  Map<String, double>? _locData;
  @override
  void initState() {
    super.initState();
    i = Provider.of<i18n>(context, listen: false);
    _locData = widget.initialLocData;
  }

  @override
  Widget build(BuildContext context) {
    print('*************** location_input build ***************');
    return GestureDetector(
      onTap: widget.isEnabled ? _onTap : null,
      child: _buildFrame(),
    );
  }

  void _onTap() async {
    final retrievedLocData =
        await Navigator.of(context).push<Map<String, double>>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          editLocationAllowed: widget.editLocationAllowed,
          initialLocData: _locData,
          title: widget.title,
        ),
      ),
    );

    if (retrievedLocData == null) return;

    setState(() => _locData = retrievedLocData);

    // send callback
    widget.onSetLocationHandler(_locData!);
  }

  Widget _buildFrame() {
    const double size = 250;
    const color = Colors.black;

    if (_locData != null) {
      return Stack(
        children: [
          buildFrameWithBorder(size, color),
          Positioned(
            bottom: 4,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      );
    } else {
      return const Icon(Icons.add_location_alt_outlined,
          color: Colors.black38, size: size / 4);
    }
  }

  Widget buildFrameWithBorder(double size, Color color) {
    // final _imagePath = LocationService.buildLocationImagePath(
    //     lat: _locData!['lat']!, long: _locData!['long']!);
    // // final _imagePath =
    // //     "https://images.pexels.com/photos/213780/pexels-photo-213780.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500";
    // final _image = Image.network(
    //   _imagePath,
    //   width: double.infinity,
    //   height: _size,
    //   fit: BoxFit.cover,
    // );
    return Container(
      width: double.infinity,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: color.withOpacity(0.40)),
      ),
      // child: _image,
      child: Center(
        child: Text(i.tr('m62'),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
      ),
    );
  }

  CircleBorderWidget buildEditIcon(Color color) {
    return CircleBorderWidget(
      // width: 1.0, // default
      // gap: 2.0, // default
      borderColor: color,
      child: IconWidget(
        icon: Icons.edit_location_alt,
        color: color.withOpacity(0.40),
      ),
    );
  }
}
