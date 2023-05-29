import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/range_slider.dart';
import 'package:tourist_admin_panel/components/selector_label.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/model/place.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/responsive.dart';
import 'package:tourist_admin_panel/services/service_io.dart';

import '../../components/skill.dart';
import '../../config/config.dart';
import '../../model/group.dart';
import '../../model/route.dart';
import '../selector.dart';

class TouristFilters extends StatefulWidget {
  const TouristFilters(
      {super.key,
      required this.onChange,
      required this.onFound,
      required this.titleNotifier});

  final VoidCallback onChange;
  final void Function(List<Tourist>) onFound;
  final ValueNotifier<String> titleNotifier;

  static final Set<Gender> selectedGenders = Gender.values.toSet();
  static final Set<SkillCategory> selectedSkillCategories =
      SkillCategory.values.toSet();
  static final ageRangeNotifier = ValueNotifier(const RangeValues(18, 40));

  @override
  State<TouristFilters> createState() => _TouristFiltersState();
}

class _TouristFiltersState extends State<TouristFilters> {
  Place? selectedPlace;
  Set<RouteTrip> selectedRoutes = HashSet();
  Group? selectedGroup;

  Color get queryColor => Colors.blueGrey;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildSelector(context,
                    prefix: "Gender",
                    items: Gender.values,
                    selectedItems: TouristFilters.selectedGenders,
                    itemBuilder: (i) => GenderView(gender: i)),
              ),
              Expanded(
                flex: 2,
                child: buildSelector(context,
                    prefix: "Skill category",
                    items: SkillCategory.values,
                    selectedItems: TouristFilters.selectedSkillCategories,
                    itemBuilder: (i) => SkillView(skillCategory: i)),
              ),
              Expanded(
                flex: 2,
                child: Column(
                    children: [
                  Config.defaultText("Age"),
                  IntRangeSlider(
                      min: 16,
                      max: 40,
                      rangeNotifier: TouristFilters.ageRangeNotifier)
                ]),
              )
            ],
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                children: [
                  ImageButton(
                      onPressed: selectPlace,
                      text: selectedPlace == null
                          ? "Select place"
                          : selectedPlace!.name,
                      imageName: "place.png"),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  Visibility(
                    visible: selectedPlace != null,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        SimpleButton(
                          color: queryColor,
                          text: "Find by place",
                          onPressed: findByPlace,
                        ),
                      ],
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  ImageButton(
                      onPressed: selectGroup,
                      text: selectedGroup == null
                          ? "Select group"
                          : selectedGroup!.name,
                      imageName: "group.png"),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  Visibility(
                    visible: selectedGroup != null,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        SimpleButton(
                          color: queryColor,
                          text: "Trainer trip",
                          onPressed: findByTrainerTrip,
                        ),
                      ],
                    ),
                  )
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  ImageButton(
                      onPressed: selectRoutes,
                      text: selectedRoutes.isEmpty
                          ? "Select routes"
                          : "${selectedRoutes.length} selected",
                      imageName: "route.png"),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  Visibility(
                    visible: selectedGroup != null && selectedRoutes.isNotEmpty,
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        SimpleButton(
                          color: queryColor,
                          text: "Find by routes",
                          onPressed: findByRoutes,
                        ),
                      ],
                    ),
                  )
                ],
              ))
            ],
          )
        ],
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Config.defaultText("Filters"),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      buildSelector(context,
          prefix: "Gender",
          items: Gender.values,
          selectedItems: TouristFilters.selectedGenders,
          itemBuilder: (i) => GenderView(gender: i)),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      buildSelector(context,
          prefix: "Skill category",
          items: SkillCategory.values,
          selectedItems: TouristFilters.selectedSkillCategories,
          itemBuilder: (i) => SkillView(skillCategory: i)),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Config.defaultText("Age"),
      Row(
        children: [
          Expanded(
              flex: 2,
              child: IntRangeSlider(
                  min: 16,
                  max: 40,
                  rangeNotifier: TouristFilters.ageRangeNotifier)),
          const Spacer(
            flex: 1,
          )
        ],
      ),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      ImageButton(
          onPressed: selectPlace,
          text: selectedPlace == null ? "Select place" : selectedPlace!.name,
          imageName: "place.png"),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Visibility(
          visible: selectedPlace != null,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  SimpleButton(
                    color: queryColor,
                    text: "Find by place",
                    onPressed: findByPlace,
                  ),
                ],
              ),
              const SizedBox(
                height: Config.defaultPadding,
              ),
            ],
          )),
      ImageButton(
          onPressed: selectGroup,
          text: selectedGroup == null ? "Select group" : selectedGroup!.name,
          imageName: "group.png"),
      Visibility(
          visible: selectedGroup != null,
          child: Column(
            children: [
              const SizedBox(
                height: Config.defaultPadding,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  SimpleButton(
                    color: queryColor,
                    text: "Trainer trip",
                    onPressed: findByTrainerTrip,
                  ),
                ],
              ),
            ],
          )),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      ImageButton(
          onPressed: selectRoutes,
          text: selectedRoutes.isEmpty
              ? "Select routes"
              : "Selected ${selectedRoutes.length} routes",
          imageName: "route.png"),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Visibility(
          visible: selectedGroup != null && selectedRoutes.isNotEmpty,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 60,
                  ),
                  SimpleButton(
                    color: queryColor,
                    text: "Find by routes",
                    onPressed: findByRoutes,
                  ),
                ],
              ),
              const SizedBox(
                height: Config.defaultPadding,
              ),
            ],
          )),
    ]);
  }

  void findByRoutes() async {
    handleRes(await TouristApi().findByRoutes(
        groupId: selectedGroup!.id,
        routes: selectedRoutes.toList()));
    widget.titleNotifier.value =
    "Tourists from group ${selectedGroup!.name} who were on selected routes";
  }

  void findByPlace() async {
    handleRes(await TouristApi()
        .findByPlace(placeId: selectedPlace!.id));
    widget.titleNotifier.value =
    "Tourists who passed ${selectedPlace!.name} in a trip";
  }

  void findByTrainerTrip() async {
    handleRes(await TouristApi()
        .findWhoHadTripWithTrainer(
        groupId: selectedGroup!.id));
    widget.titleNotifier.value =
    "Tourists from group ${selectedGroup!.name} who had trip with trainer as instructor";
  }

  void selectPlace() {
    Selector.selectPlace(context, barrierColor: Colors.black54,
        onSelected: (p) async {
      Navigator.of(context).pop();
      setState(() {
        selectedPlace = p;
      });
    });
  }

  void selectGroup() {
    Selector.selectGroup(context, barrierColor: Colors.black54,
        onSelected: (p) async {
      Navigator.of(context).pop();
      setState(() {
        selectedGroup = p;
      });
    });
  }

  void selectRoutes() {
    Selector.selectRoutes(context,
        barrierColor: Colors.black54, selected: selectedRoutes, onDispose: () {
      Future.delayed(const Duration(milliseconds: 10), () async {
        setState(() {});
      });
    });
  }

  void handleRes(List<Tourist>? res) async {
    if (res == null) {
      ServiceIO()
          .showMessage("Could not get the elems from server :/", context);
      return;
    }
    widget.onFound(res);
  }

  Widget buildSelector<T>(BuildContext context,
      {required String prefix,
      required List<T> items,
      required Widget Function(T) itemBuilder,
      required Set<T> selectedItems}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Config.defaultText(prefix),
        const SizedBox(
          height: Config.defaultPadding,
        ),
        SelectorLabel(
          items: items,
          itemBuilder: itemBuilder,
          selectedItems: selectedItems,
          onChange: () {
            widget.titleNotifier.value = "By gender, skill and age";
            widget.onChange();
          },
        )
      ],
    );
  }
}
