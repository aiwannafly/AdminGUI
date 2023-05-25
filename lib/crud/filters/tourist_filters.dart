import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/range_slider.dart';
import 'package:tourist_admin_panel/components/selector_label.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/responsive.dart';

import '../../components/skill.dart';
import '../../config/config.dart';

class TouristFilters extends StatelessWidget {
  const TouristFilters({super.key, required this.onChange});

  final VoidCallback onChange;

  static final Set<Gender> selectedGenders = Gender.values.toSet();
  static final Set<SkillCategory> selectedSkillCategories =
      SkillCategory.values.toSet();
  static final ageRangeNotifier = ValueNotifier(const RangeValues(18, 40));

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Row(
        children: [
          Expanded(
            child: buildSelector(context,
                prefix: "Gender",
                items: Gender.values,
                selectedItems: selectedGenders,
                itemBuilder: (i) => GenderView(gender: i)),
          ),
          Expanded(
            flex: 2,
            child: buildSelector(context,
                prefix: "Skill category",
                items: SkillCategory.values,
                selectedItems: selectedSkillCategories,
                itemBuilder: (i) => SkillView(skillCategory: i)),
          ),
          Expanded(
            flex: 2,
            child: Column(children: [
              Config.defaultText("Age"),
              IntRangeSlider(min: 16, max: 40, rangeNotifier: ageRangeNotifier)
            ]),
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
          selectedItems: selectedGenders,
          itemBuilder: (i) => GenderView(gender: i)),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      buildSelector(context,
          prefix: "Skill category",
          items: SkillCategory.values,
          selectedItems: selectedSkillCategories,
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
                  min: 16, max: 40, rangeNotifier: ageRangeNotifier)),
          const Spacer(
            flex: 1,
          )
        ],
      )
    ]);
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
          onChange: onChange,
        )
      ],
    );
  }
}
