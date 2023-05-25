import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_picker_free/map_picker_free.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/model/place.dart';

import '../../config/config.dart';
import '../../services/service_io.dart';

class PlaceForm extends StatefulWidget {
  const PlaceForm({super.key, required this.onSubmit, this.initial});

  final Function(Place) onSubmit;
  final Place? initial;

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  var builder = PlaceBuilder();
  var nameController = TextEditingController();
  LatLong? currLatLong;
  String? currAddress;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = PlaceBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      currLatLong = LatLong(builder.latitude, builder.longitude);
      currAddress = builder.address;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "place",
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageBox(imageName: "place.png"),
            const SizedBox(
              width: Config.defaultPadding,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                SizedBox(
                  width: 300,
                  child: InputLabel(
                    controller: nameController,
                    hintText: "Place name",
                  ),
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                ImageButton(
                    onPressed: pickPlace,
                    text: currLatLong == null
                        ? "Select on map"
                        : "${currLatLong!.latitude.toStringAsFixed(3)} ${currLatLong!.longitude.toStringAsFixed(3)}",
                    imageName: "map.png")
              ],
            ),
          ],
        ));
  }

  void buildEntity() {
    builder.name = nameController.text;
    if (builder.name.isEmpty) {
      ServiceIO().showMessage("Name must not be empty", context);
      return;
    }
    if (currLatLong == null) {
      ServiceIO().showMessage("Select the place on a map", context);
      return;
    }
    builder.address = currAddress!;
    builder.longitude = currLatLong!.longitude;
    builder.latitude = currLatLong!.latitude;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void pickPlace() async {
    Position pos = await _determinePosition();
    await Future.microtask(() async {
      ServiceIO().showWidget(context,
          child: SizedBox(
            height: Config.pageHeight(context) * .8,
            width: Config.pageWidth(context) * .8,
            child: MapPicker(
                center: LatLong(pos.latitude, pos.longitude),
                onPicked: (pickedData) {
                  currLatLong = pickedData.latLong;
                  currAddress = pickedData.address;
                  Navigator.of(context).pop();
                  setState(() {});
                }),
          ));
    });
    setState(() {});
  }
}
