import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/route_api.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/services/service_io.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/place.dart';
import '../../model/route.dart';
import '../../model/section.dart';

enum RouteFilterState {
  showAll,
  byMinLengthKm,
  byPlace,
  byTripsCount,
  byInstructor,
  byDate,
  bySection
}

extension on RouteFilterState {
  String get viewName {
    return switch (this) {
      RouteFilterState.showAll => "Show all",
      RouteFilterState.byDate => "By date",
      RouteFilterState.byInstructor => "By instructor",
      RouteFilterState.byMinLengthKm => "By min length",
      RouteFilterState.byPlace => "By place",
      RouteFilterState.bySection => "By section",
      RouteFilterState.byTripsCount => "By trips count"
    };
  }
}

class RouteFilters extends StatefulWidget {
  const RouteFilters({super.key, required this.onUpdate});

  final void Function(List<RouteTrip> routes) onUpdate;

  @override
  State<RouteFilters> createState() => _RouteFiltersState();
}

class _RouteFiltersState extends State<RouteFilters> {
  RouteFilterState state = RouteFilterState.showAll;
  final lengthNotifier = ValueNotifier(defaultLengthKm);
  final tripsCountNotifier = ValueNotifier(1);
  Place? selectedPlace;
  Tourist? selectedInstructor;
  Section? selectedSection;
  DateTime selectedDate = DateTime.now();

  void handleResult(List<RouteTrip>? res) {
    if (res == null) {
      Future.microtask(() =>
          ServiceIO().showMessage("Could not connect to server", context));
      return;
    }
    widget.onUpdate(res);
  }

  void onMinLengthUpdate() async {
    handleResult(await RouteApi().findRoutesByMinLengthKm(lengthNotifier.value));
  }

  void onTripsCountUpdate() async {
    handleResult(await RouteApi().findRoutesByTripsCount(tripsCountNotifier.value));
  }

  @override
  void initState() {
    super.initState();
    lengthNotifier.addListener(onMinLengthUpdate);
    tripsCountNotifier.addListener(onTripsCountUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    lengthNotifier.removeListener(onMinLengthUpdate);
    tripsCountNotifier.removeListener(onTripsCountUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: Config.defaultPadding,
        ),
        Config.defaultText("Filters"),
        const SizedBox(
          height: Config.defaultPadding,
        ),
        DropdownMenu(
            onSelected: (val) {
              if (val != null) {
                setState(() {
                  state = val;
                });
              }
            },
            menuStyle: MenuStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Config.secondaryColor),
              // side: MaterialStateProperty.all(const BorderSide(width: 0))
            ),
            initialSelection: state,
            dropdownMenuEntries: RouteFilterState.values
                .map((e) => DropdownMenuEntry(value: e, label: e.viewName))
                .toList()),
        const SizedBox(
          height: Config.defaultPadding,
        ),
        Visibility(
          visible: state == RouteFilterState.byMinLengthKm,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SliderTextSetter<int>(
                    minVal: minLengthKm,
                    maxVal: maxLengthKm,
                    divisions: (maxLengthKm - minLengthKm),
                    notifier: lengthNotifier,
                    leadingText: "Select min. length in km."),
              ),
              const Spacer(
                flex: 1,
              )
            ],
          ),
        ),
        Visibility(
            visible: state == RouteFilterState.byPlace,
            child: ImageButton(
              onPressed: selectPlace,
              imageName: "place.png",
              text:
                  selectedPlace == null ? "Select place" : selectedPlace!.name,
            )),
        Visibility(
            visible: state == RouteFilterState.byTripsCount,
            child: Row(
              children: [
                Expanded(
                    child: SliderTextSetter(
                        minVal: 0,
                        maxVal: 100,
                        notifier: tripsCountNotifier,
                        leadingText: "Select trips count")),
                const Spacer()
              ],
            )),
        Visibility(
            visible: state == RouteFilterState.byInstructor,
            child: ImageButton(
              onPressed: selectInstructor,
              imageName: "trainer.png",
              text: selectedInstructor == null
                  ? "Select instructor"
                  : "${selectedInstructor!.firstName} ${selectedInstructor!.secondName}",
            )),
        Visibility(
            visible: state == RouteFilterState.byDate,
            child: ImageButton(
              onPressed: selectDate,
              imageName: "schedule.png",
              text: dateTimeToStr(selectedDate),
            )),
        Visibility(
            visible: state == RouteFilterState.bySection,
            child: ImageButton(
              onPressed: selectSection,
              imageName: "section.png",
              text: selectedSection == null
                  ? "Select section"
                  : selectedSection!.name,
            )),
      ],
    );
  }

  void selectPlace() {
    Selector.selectPlace(context, barrierColor: Colors.black54,
        onSelected: (r) async {
      Navigator.of(context).pop();
      setState(() {
        selectedPlace = r;
      });
      handleResult(await RouteApi().findRoutesByPlace(selectedPlace!));
    });
  }

  void selectInstructor() {
    Selector.selectInstructor(context, barrierColor: Colors.black54,
        onSelected: (r) async {
      Navigator.of(context).pop();
      setState(() {
        selectedInstructor = r;
      });
      handleResult(await RouteApi().findRoutesByInstructor(selectedInstructor!));
    });
  }

  void selectSection() {
    Selector.selectSection(context, barrierColor: Colors.black54,
        onSelected: (r) async {
      Navigator.of(context).pop();
      setState(() {
        selectedSection = r;
      });
      handleResult(await RouteApi().findRoutesBySection(selectedSection!));
    });
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate.subtract(const Duration(days: 300)),
        lastDate: selectedDate.add(const Duration(days: 300)));
    if (newTime != null) {
      setState(() {
        selectedDate = newTime;
      });
      handleResult(await RouteApi().findRoutesByDate(selectedDate));
    }
  }
}
