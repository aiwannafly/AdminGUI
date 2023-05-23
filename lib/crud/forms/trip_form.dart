import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_select_list.dart';
import 'package:tourist_admin_panel/model/route.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/route_api.dart';
import '../../api/tourist_api.dart';
import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/trip.dart';
import '../../services/service_io.dart';
import '../../utils.dart';
import '../base_crud_future_builder.dart';
import '../filters/tourist_filters.dart';
import '../route_crud.dart';
import '../tourist_crud.dart';

class TripForm extends StatefulWidget {
  const TripForm({super.key, required this.onSubmit, this.initial});

  final Function(Trip) onSubmit;
  final Trip? initial;

  @override
  State<TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  var builder = TripBuilder();
  RouteTrip? currentRoute;
  Tourist? currInstructor;
  Set<Tourist> selected = HashSet();
  static const defaultDurationDays = 3;
  final durationNotifier = ValueNotifier(defaultDurationDays);

  @override
  void initState() {
    super.initState();
    durationNotifier.addListener(updateDuration);
    if (widget.initial != null) {
      builder = TripBuilder.fromExisting(widget.initial!);
      currentRoute = builder.route;
      currInstructor = builder.instructor;
      durationNotifier.value = builder.durationDays;
      selected.addAll(builder.tourists);
      return;
    }
    builder.id = 0;
    builder.requiredSkillCategory = SkillCategory.beginner;
    builder.durationDays = defaultDurationDays;
    builder.startDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    durationNotifier.removeListener(updateDuration);
  }

  void updateDuration() {
    builder.durationDays = durationNotifier.value;
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
              "$actionName trip",
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
                        child: Image.asset("assets/images/trip.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding * 3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/trainer.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectInstructor,
                              color: Config.secondaryColor,
                              text: currInstructor == null
                                  ? "Select instructor"
                                  : "${currInstructor!.firstName} ${currInstructor!.secondName}")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/route.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectRoute,
                              color: Config.secondaryColor,
                              text: currentRoute == null
                                  ? "Select route"
                                  : currentRoute!.name)
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/group.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectTourists,
                              color: Config.secondaryColor,
                              text: selected.isEmpty ? "Select tourists" :
                          "Selected ${selected.length} tourists")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/time.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectDate,
                              color: Config.secondaryColor,
                              text: "Start date ${dateTimeToStr(builder.startDate)}")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,)
                ],
              )
            ],
          ),
          const SizedBox(
            height: Config.defaultPadding,),
          Config.defaultText("Select skill category for the trip"),
          const SizedBox(
            height: Config.defaultPadding,),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ToggleSwitch(
              minWidth: 140.0,
              initialLabelIndex: builder.requiredSkillCategory.index,
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
              onToggle: (index) {
                if (index == null) return;
                setState(() {
                  builder.requiredSkillCategory = SkillCategory.values[index];
                });
              },
            ),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          SizedBox(
            width: 450,
            child: SliderTextSetter<int>(
                minVal: 2,
                maxVal: 60,
                notifier: durationNotifier,
                leading: "Duration in days"),
          ),
          const SizedBox(
            height: Config.defaultPadding * 2,
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
                    if (currInstructor == null) {
                      ServiceIO()
                          .showMessage("Instructor is not selected", context);
                      return;
                    }
                    if (currentRoute == null) {
                      ServiceIO()
                          .showMessage("Route is not selected", context);
                      return;
                    }
                    builder.tourists = selected.toList();
                    if (builder.tourists.isEmpty) {
                      ServiceIO()
                          .showMessage("Select tourists for the trip", context);
                      return;
                    }
                    builder.durationDays = durationNotifier.value;
                    builder.instructor = currInstructor!;
                    builder.route = currentRoute!;
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

  void selectInstructor() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => SizedBox(
                child: TouristCRUD(
                  tourists: tourists,
                  onTap: (s) {
                    currInstructor = s;
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  filtersFlex: 1,
                  itemHoverColor: Colors.grey,
                ),
              ),
            ),
          ),
        ));
  }

  void selectRoute() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<RouteTrip>(
              itemsGetter: RouteApi().getAll(),
              contentBuilder: (items) => RouteCRUD(
                items: items,
                onTap: (s) {
                  currentRoute = s;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ),
          ),
        ));
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: builder.startDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (newTime != null) {
      setState(() {
        builder.startDate = newTime;
      });
    }
  }

  void selectTourists() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                onDispose: () {
                  Future.delayed(const Duration(milliseconds: 10), () {
                    setState(() {
                    });
                  });
                },
                filtersFlex: 2,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }
}
