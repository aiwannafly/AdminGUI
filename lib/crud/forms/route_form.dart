import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/crud/forms/place_select_list.dart';

import '../../api/place_api.dart';
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
    return Container(
      decoration: const BoxDecoration(
        borderRadius: Config.borderRadius,
        color: Config.bgColor,
      ),
      padding: Config.paddingAll,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$actionName route",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                        borderRadius: Config.borderRadius,
                        child: Image.asset("assets/images/route.png")),
                  )),
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
                      hintText: "Route name",
                    ),
                  ),
                  const SizedBox(
                    height: Config.defaultPadding * 2,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/place.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectPlaces,
                              color: Config.secondaryColor,
                              text: selected.isEmpty ? "Select places" :
                              "Selected ${selected.length} places")
                        ],
                      )),
                ],
              )
            ],
          ),
          Config.defaultText("Select route type"),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ToggleSwitch(
              minWidth: 120,
              initialLabelIndex: builder.routeType.index,
              cornerRadius: Config.defaultRadius,
              activeFgColor: Colors.black,
              inactiveBgColor: Config.secondaryColor,
              inactiveFgColor: Colors.white,
              totalSwitches: RouteType.values.length,
              animate: true,
              animationDuration: 200,
              labels: RouteType.values.map((e) => e.string).toList(),
              activeBgColor: const [Colors.blue],
              customTextStyles: List.filled(
                  RouteType.values.length,
                  TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Colors.grey.shade200)),
              onToggle: (index) {
                if (index == null) return;
                setState(() {
                  builder.routeType = RouteType.values[index];
                });
              },
            ),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          SizedBox(
            width: 400,
            child: SliderTextSetter<int>(
                minVal: minLengthKm,
                maxVal: maxLengthKm,
                divisions: (maxLengthKm - minLengthKm),
                notifier: lengthNotifier,
                leading: "Select length in km."),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Container(
                    padding: Config.paddingAll,
                    child: Text("Cancel",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
              ElevatedButton(
                  onPressed: () {
                    builder.name = nameController.text;
                    if (builder.name.isEmpty) {
                      ServiceIO()
                          .showMessage("Name must not be empty", context);
                      return;
                    }
                    builder.places = selected.toList();
                    Navigator.of(context).pop();
                    widget.onSubmit(builder.build());
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Container(
                    padding: Config.paddingAll,
                    child: Text(actionName,
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void selectPlaces() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Place>(
              itemsGetter: PlaceApi().getAll(),
              contentBuilder: (items) => PlaceSelectList(
                places: items,
                onDispose: () {
                  Future.delayed(const Duration(milliseconds: 10), () {
                    setState(() {
                    });
                  });
                },
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }
}
