import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';

import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/route.dart';

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
      RouteFilterState.byMinLengthKm => "By length",
      RouteFilterState.byPlace => "By place",
      RouteFilterState.bySection => "By section",
      RouteFilterState.byTripsCount => "By trips count"
    };
  }
}

class RouteFilters extends StatefulWidget {
  const RouteFilters({super.key, required this.shownRoutes});

  final List<RouteTrip> shownRoutes;

  @override
  State<RouteFilters> createState() => _RouteFiltersState();
}

class _RouteFiltersState extends State<RouteFilters> {
  RouteFilterState state = RouteFilterState.showAll;
  final lengthNotifier = ValueNotifier(defaultLengthKm);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Config.defaultText("Filters"),
        const SizedBox(
          height: Config.defaultPadding * 2,
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
                    leading: "Select min. length in km."),
              ),
              const Spacer(flex: 1,)
            ],
          ),
        ),

      ],
    );
  }
}
