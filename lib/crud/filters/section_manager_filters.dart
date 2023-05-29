import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/range_slider.dart';
import 'package:tourist_admin_panel/components/selector_label.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/responsive.dart';

import '../../config/config.dart';

class SectionManagerFilters extends StatelessWidget {
  const SectionManagerFilters({super.key, required this.onChange});

  final VoidCallback onChange;

  static final ageRangeNotifier = ValueNotifier(const RangeValues(20, 60));
  static final employmentYearNotifier =
      ValueNotifier(RangeValues(2000, DateTime.now().year.toDouble()));
  static final salaryRangeNotifier = ValueNotifier(RangeValues(
      minSectionManagerSalary.toDouble(), maxSectionManagerSalary.toDouble()));

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Row(
        children: [
          Expanded(
            flex: 2,
              child: Column(
            children: [
              Config.defaultText("Employment year"),
              IntRangeSlider(
                  min: 2000,
                  max: DateTime.now().year,
                  rangeNotifier: employmentYearNotifier)
            ],
          )),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Config.defaultText("Age"),
                  IntRangeSlider(
                      min: 20, max: 60, rangeNotifier: ageRangeNotifier)
                ],
              )),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Config.defaultText("Salary"),
                  IntRangeSlider(
                      min: minSectionManagerSalary,
                      max: maxSectionManagerSalary,
                      divisions:
                      (maxSectionManagerSalary - minSectionManagerSalary) ~/
                          salaryPortion,
                      rangeNotifier: salaryRangeNotifier)
                ],
              )),
        ],
      );
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Config.defaultText("Filters"),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Config.defaultText("Employment year"),
      Row(
        children: [
          Expanded(
              flex: 2,
              child: IntRangeSlider(
                  min: 2000,
                  max: DateTime.now().year,
                  rangeNotifier: employmentYearNotifier)),
          const Spacer(
            flex: 1,
          )
        ],
      ),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Config.defaultText("Age"),
      Row(
        children: [
          Expanded(
              flex: 2,
              child: IntRangeSlider(
                  min: 20, max: 60, rangeNotifier: ageRangeNotifier)),
          const Spacer(
            flex: 1,
          )
        ],
      ),
      const SizedBox(
        height: Config.defaultPadding,
      ),
      Config.defaultText("Salary"),
      Row(
        children: [
          Expanded(
              flex: 2,
              child: IntRangeSlider(
                  min: minSectionManagerSalary,
                  max: maxSectionManagerSalary,
                  divisions:
                      (maxSectionManagerSalary - minSectionManagerSalary) ~/
                          salaryPortion,
                  rangeNotifier: salaryRangeNotifier)),
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
