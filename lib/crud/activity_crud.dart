import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/activity.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../api/activity_api.dart';
import 'forms/activity_form.dart';

class ActivityCRUD extends StatefulWidget {
  const ActivityCRUD(
      {super.key,
      required this.items,
      this.onTap,
      this.itemHoverColor,
      required this.filtersFlex});

  final List<Activity> items;
  final void Function(Activity)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<ActivityCRUD> createState() => _ActivityCRUDState();
}

class _ActivityCRUDState extends State<ActivityCRUD> {
  List<Activity> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Activity>(
        title: "Activities",
        items: items,
        columns: [
          ColumnData<Activity>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Activity>(
              name: "Group",
              buildColumnElem: (e) => centeredText(e.schedule.group.name),
              flex: 2),
          ColumnData<Activity>(
              name: "Trainer",
              buildColumnElem: (e) => centeredText(
                  "${e.schedule.group.trainer.tourist.firstName} ${e.schedule.group.trainer.tourist.secondName}"),
              flex: 2),
          ColumnData<Activity>(
              name: "Duration, mins",
              buildColumnElem: (e) => centeredText(e.schedule.durationMins.toString()),
              flex: 2),
          ColumnData<Activity>(
              name: "Date",
              buildColumnElem: (e) => centeredText(dateTimeToStr(e.date)),
              flex: 2)
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: ActivityApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder(
      {required Function(Activity) onSubmit, Activity? initial}) {
    return ActivityForm(onSubmit: onSubmit, initial: initial);
  }

  Widget centeredText(String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      )
    );
  }

  Widget buildFilters() {
    if (widget.filtersFlex == 0) return const SizedBox();
    return Flexible(flex: widget.filtersFlex, child: Container());
  }
}
