import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/forms/sсhedule_form.dart';
import 'package:tourist_admin_panel/model/schedule.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../api/schedule_api.dart';

class ScheduleCRUD extends StatefulWidget {
  const ScheduleCRUD(
      {super.key,
        required this.items,
        this.onTap,
        this.itemHoverColor,
        required this.filtersFlex});

  final List<Schedule> items;
  final void Function(Schedule)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<ScheduleCRUD> createState() => _ScheduleCRUDState();
}

class _ScheduleCRUDState extends State<ScheduleCRUD> {
  List<Schedule> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Schedule>(
        title: "Schedule",
        items: items,
        columns: [
          ColumnData<Schedule>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Schedule>(
              name: "Group",
              buildColumnElem: (e) => centeredText(e.group.name),
              flex: 2),
          ColumnData<Schedule>(
              name: "Section",
              buildColumnElem: (e) => centeredText(e.group.trainer.section.name),
              flex: 3),
          ColumnData<Schedule>(
              name: "Trainer",
              buildColumnElem: (e) => centeredText('${e.group.trainer.tourist.firstName} ${e.group.trainer.tourist.secondName}'),
              flex: 3),
          ColumnData<Schedule>(
              name: "Duration, mins",
              buildColumnElem: (e) => centeredText(e.durationMins.toString()),
              flex: 2),
          ColumnData<Schedule>(
              name: "Day of week",
              buildColumnElem: (e) => centeredText(e.dayOfWeek.string),
              flex: 2),
          ColumnData<Schedule>(
              name: "Time of day",
              buildColumnElem: (e) => centeredText(timeOfDayToStr(e.timeOfDay)),
              flex: 2),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: ScheduleApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Schedule) onSubmit, Schedule? initial}) {
    return ScheduleForm(onSubmit: onSubmit, initial: initial);
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
    return Flexible(flex: widget.filtersFlex, child: Container());
  }
}
