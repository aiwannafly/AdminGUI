import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/api/instructor_api.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/services/service_io.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/place.dart';
import '../../model/route.dart';
import '../../model/trip.dart';
import '../../responsive.dart';

enum InstructorFilterState {
  showAll,
  onlyTrainers,
  onlySportsmen,
  byRoutes,
  byTripsCount,
  byTrip,
  byCategory,
  byPlace,
}

extension on InstructorFilterState {
  String get viewName {
    return switch (this) {
    InstructorFilterState.showAll =>
    "Show all"
    ,
    InstructorFilterState.byPlace => "By place",
    InstructorFilterState.byTripsCount => "By trips count",
    InstructorFilterState.onlyTrainers => "Only trainers",
    InstructorFilterState.onlySportsmen => "Only sportsmen",
    InstructorFilterState.byTrip => "By trip",
    InstructorFilterState.byRoutes => "By routes",
    InstructorFilterState.byCategory
    =>
    "By category"
    ,
  };
  }
}

class InstructorFilters extends StatefulWidget {
  const InstructorFilters({super.key, required this.onUpdate,
    required this.titleNotifier});

  final void Function(List<Tourist> routes) onUpdate;
  final ValueNotifier<String> titleNotifier;

  @override
  State<InstructorFilters> createState() => _InstructorFiltersState();
}

class _InstructorFiltersState extends State<InstructorFilters> {
  InstructorFilterState state = InstructorFilterState.showAll;
  final tripsCountNotifier = ValueNotifier(1);
  Place? selectedPlace;
  Trip? selectedTrip;
  Set<RouteTrip> selectedRoutes = HashSet();
  SkillCategory selectedCategory = SkillCategory.intermediate;

  void handleResult(List<Tourist>? res) {
    if (res == null) {
      Future.microtask(() =>
          ServiceIO().showMessage("Could not connect to server", context));
      return;
    }
    widget.onUpdate(res);
  }

  void onTripsCountUpdate() async {
    handleResult(
        await InstructorApi().findByTripsCount(tripsCountNotifier.value));
    widget.titleNotifier.value =
    "Instructors, who had ${tripsCountNotifier.value} trips";
  }

  @override
  void initState() {
    super.initState();
    tripsCountNotifier.addListener(onTripsCountUpdate);
  }

  @override
  void dispose() {
    super.dispose();
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
            onSelected: (val) async {
              if (val != null) {
                setState(() {
                  state = val;
                });
                if (state == InstructorFilterState.showAll) {
                  handleResult(await InstructorApi().getAll());
                  widget.titleNotifier.value = "All instructors";
                }
                if (state == InstructorFilterState.onlyTrainers) {
                  handleResult(await InstructorApi().getAllTrainers());
                  widget.titleNotifier.value = "Instructors-trainers";
                }
                if (state == InstructorFilterState.onlySportsmen) {
                  handleResult(await InstructorApi().getAllSportsmen());
                  widget.titleNotifier.value = "Instructors-sportsmen";
                }
              }
            },
            menuStyle: MenuStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Config.secondaryColor),
              // side: MaterialStateProperty.all(const BorderSide(width: 0))
            ),
            initialSelection: state,
            dropdownMenuEntries: InstructorFilterState.values
                .map((e) => DropdownMenuEntry(value: e, label: e.viewName))
                .toList()),
        const SizedBox(
          height: Config.defaultPadding,
        ),
        Visibility(
            visible: state == InstructorFilterState.byPlace,
            child: ImageButton(
              onPressed: selectPlace,
              imageName: "place.png",
              text:
              selectedPlace == null ? "Select place" : selectedPlace!.name,
            )),
        Visibility(
            visible: state == InstructorFilterState.byRoutes,
            child: ImageButton(
              onPressed: selectRoutes,
              imageName: "route.png",
              text:
              selectedRoutes.isEmpty
                  ? "Select routes"
                  : "Selected ${selectedRoutes.length} routes",
            )),
        Visibility(
            visible: state == InstructorFilterState.byTrip,
            child: ImageButton(
              onPressed: selectTrip,
              imageName: "trip.png",
              text:
              selectedTrip == null ? "Select trip" : "${selectedTrip!.route
                  .name} ${dateTimeToStr(selectedTrip!.startDate)}",
            )),
        Visibility(
            visible: state == InstructorFilterState.byTripsCount,
            child: SliderTextSetter(
                        minVal: 0,
                        maxVal: 100,
                        notifier: tripsCountNotifier,
                        leadingText: "Select trips count")),
        Visibility(
          visible: state == InstructorFilterState.byCategory,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ToggleSwitch(
              minWidth: 150.0,
              isVertical: Responsive.isDesktop(context),
              initialLabelIndex: selectedCategory.index,
              cornerRadius: Config.defaultRadius,
              activeFgColor: Colors.black,
              inactiveBgColor: Config.secondaryColor,
              inactiveFgColor: Colors.white,
              totalSwitches: 3,
              animate: true,
              animationDuration: 200,
              labels: const ['Beginner', 'Intermediate', 'Advanced'],
              activeBgColors: const [
                [Colors.green],
                [Colors.deepOrangeAccent],
                [Colors.red]
              ],
              customTextStyles: [
                Config.defaultTextStyle(),
                Config.defaultTextStyle(),
                Config.defaultTextStyle(),
              ],
              onToggle: (index) async {
                if (index == null) return;
                setState(() {
                  selectedCategory = SkillCategory.values[index];
                });
                handleResult(await InstructorApi().findBySkillCategory(
                    selectedCategory));
                widget.titleNotifier.value =
                "Instructors with ${selectedCategory.string} category";
              },
            ),
          ),)
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
          handleResult(await InstructorApi().findByPlaceId(selectedPlace!.id));
          widget.titleNotifier.value =
          "Instructors, who were at ${selectedPlace!.name}";
        });
  }

  void selectTrip() {
    Selector.selectTrip(context, barrierColor: Colors.black54,
        onSelected: (r) async {
          Navigator.of(context).pop();
          setState(() {
            selectedTrip = r;
          });
          handleResult(await InstructorApi().findByTripId(selectedTrip!.id));
          widget.titleNotifier.value =
          "Instructor, who had trip ${selectedTrip!.route.name} ${dateTimeToStr(
              selectedTrip!.startDate)}";
        });
  }

  void selectRoutes() {
    Selector.selectRoutes(context,
        barrierColor: Colors.black54, selected: selectedRoutes, onDispose: () {
          Future.delayed(const Duration(milliseconds: 10), () async {
            setState(() {});
            handleResult(await InstructorApi().findByRoutes(
                routes: selectedRoutes.toList()));
            widget.titleNotifier.value =
            "Instructors, who were at the selected routes";
          });
        });
  }
}
