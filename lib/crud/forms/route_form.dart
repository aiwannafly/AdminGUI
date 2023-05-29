import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/components/route_type_view.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/select_lists/place_select_list.dart';
import 'package:tourist_admin_panel/crud/selector.dart';

import '../../api/place_api.dart';
import '../../components/image_box.dart';
import '../../components/image_button.dart';
import '../../components/simple_button.dart';
import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/place.dart';
import '../../model/route.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';

class RouteForm extends StatefulWidget {
  const RouteForm({super.key, required this.onSubmit, this.initial});

  final Function(RouteTrip) onSubmit;
  final RouteTrip? initial;

  @override
  State<RouteForm> createState() => _RouteFormState();
}

class _RouteFormState extends State<RouteForm> {
  var builder = RouteBuilder();
  var nameController = TextEditingController();
  final lengthNotifier = ValueNotifier(defaultLengthKm);
  final Set<Place> selected = HashSet();

  @override
  void initState() {
    super.initState();
    lengthNotifier.addListener(updateLengthKm);
    if (widget.initial != null) {
      builder = RouteBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      lengthNotifier.value = builder.lengthKm;
      selected.addAll(builder.places);
      return;
    }
    builder.id = 0;
    builder.lengthKm = defaultLengthKm;
    builder.routeType = RouteType.pedestrian;
  }

  @override
  void dispose() {
    super.dispose();
    lengthNotifier.removeListener(updateLengthKm);
  }

  void updateLengthKm() {
    builder.lengthKm = lengthNotifier.value;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "route",
        formType: widget.initial == null ? FormType.create : FormType.update,
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageBox(
                  imageName: "route.png",
                ),
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
                      width: BaseForm.defaultLabelWidth,
                      child: InputLabel(
                        controller: nameController,
                        hintText: "Route name",
                      ),
                    ),
                    const SizedBox(
                      height: Config.defaultPadding * 2,
                    ),
                    ImageButton(
                      onPressed: selectPlaces,
                      text: selected.isEmpty
                          ? "Select places"
                          : "Selected ${selected.length} places",
                      imageName: "place.png",
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Config.defaultText("Route type :"),
                const SizedBox(
                  width: Config.defaultPadding,
                ),
                DropdownMenu(
                    onSelected: (val) {
                      if (val != null) {
                        setState(() {
                          builder.routeType = val;
                        });
                      }
                    },
                    menuStyle: MenuStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Config.secondaryColor),
                      // side: MaterialStateProperty.all(const BorderSide(width: 0))
                    ),
                    initialSelection: builder.routeType,
                    leadingIcon: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Config.defaultPadding),
                        child: RouteTypeView(
                          routeType: builder.routeType,
                          size: 30,
                        )),
                    dropdownMenuEntries: RouteType.values
                        .map((e) => DropdownMenuEntry(
                            value: e,
                            label: e.string,
                            leadingIcon: RouteTypeView(routeType: e)))
                        .toList()),
              ],
            ),
            const SizedBox(
              height: Config.defaultPadding,
            ),
            SliderTextSetter(
                minVal: minLengthKm,
                maxVal: maxLengthKm,
                notifier: lengthNotifier,
                leadingText: "Route length")
          ],
        ));
  }

  void buildEntity() {
    builder.name = nameController.text;
    if (builder.name.isEmpty) {
      ServiceIO().showMessage("Name must not be empty", context);
      return;
    }
    builder.places = selected.toList();
    widget.onSubmit(builder.build());
  }

  void selectPlaces() {
    Selector.selectPlaces(context, selected: selected, onDispose: () {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {});
      });
    });
  }
}
