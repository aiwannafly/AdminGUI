import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/skill.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../api/trip_api.dart';
import 'forms/trip_form.dart';

class TripCRUD extends StatefulWidget {
  const TripCRUD(
      {super.key,
      required this.items,
      this.onTap,
      this.itemHoverColor,
      required this.filtersFlex});

  final List<Trip> items;
  final void Function(Trip)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<TripCRUD> createState() => _TripCRUDState();
}

class _TripCRUDState extends State<TripCRUD> {
  List<Trip> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Trip>(
        title: "Trips",
        items: items,
        columns: [
          ColumnData<Trip>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Trip>(
              name: "Start date",
              buildColumnElem: (e) => centeredText(dateTimeToStr(e.startDate)),
              flex: 2),
          ColumnData<Trip>(
              name: "Duration, days",
              buildColumnElem: (e) => centeredText(e.durationDays.toString()),
              flex: 2),
          ColumnData<Trip>(
              name: "Instructor",
              buildColumnElem: (e) => centeredText(
                  "${e.instructor.firstName} ${e.instructor.secondName}"),
              flex: 2),
          ColumnData<Trip>(
              name: "Route",
              buildColumnElem: (e) => centeredText(e.route.name),
              flex: 2),
          ColumnData<Trip>(
              name: "Required skill",
              buildColumnElem: (e) =>
                  SkillView(skillCategory: e.requiredSkillCategory),
              flex: 3),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: TripApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Trip) onSubmit, Trip? initial}) {
    return TripForm(
      onSubmit: onSubmit,
      initial: initial,
    );
  }

  Widget centeredText(String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget buildFilters() {
    if (widget.filtersFlex == 0) return const SizedBox();
    return Expanded(flex: widget.filtersFlex, child: Container());
  }
}
