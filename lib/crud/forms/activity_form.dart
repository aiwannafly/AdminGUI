import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../config/config.dart';
import '../../model/activity.dart';
import '../../model/schedule.dart';
import '../../services/service_io.dart';
import '../selector.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, required this.onSubmit, this.initial});

  final Function(Activity) onSubmit;
  final Activity? initial;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  var builder = ActivityBuilder();
  Schedule? currentSchedule;
  Set<Tourist> attended = HashSet();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = ActivityBuilder.fromExisting(widget.initial!);
      currentSchedule = builder.schedule;
      attended.addAll(builder.attended);
      return;
    }
    builder.id = 0;
    builder.date = DateTime.now();
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "activity",
        formType: widget.initial == null ? FormType.create : FormType.update,
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageBox(imageName: "activity.png"),
                const SizedBox(
                  width: Config.defaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectSchedule,
                        width: 350,
                        text: currentSchedule == null
                            ? "Select schedule"
                            : "${currentSchedule!.group.name} ${currentSchedule!.dayOfWeek.string} ${timeOfDayToStr(currentSchedule!.timeOfDay)}",
                        imageName: "schedule.png"),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectDate,
                        width: 350,
                        text: dateTimeToStr(builder.date),
                        imageName: "time.png"),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectAttended,
                        width: 350,
                        text: attended.isEmpty
                            ? "Mark attendance"
                            : "Attended ${attended.length} students",
                        imageName: "group.png"),
                  ],
                )
              ],
            )
          ],
        ));
  }

  void buildEntity() {
    if (currentSchedule == null) {
      ServiceIO().showMessage("Schedule is not selected", context);
      return;
    }
    builder.attended = attended.toList();
    builder.schedule = currentSchedule!;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  void selectAttended() {
    Selector.selectTourists(context, selected: attended, onDispose: () {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {});
      });
    });
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: builder.date,
        firstDate: DateTime(builder.date.year - 1),
        lastDate: DateTime(builder.date.year + 1));
    if (newTime != null) {
      setState(() {
        builder.date = newTime;
      });
    }
  }

  void selectSchedule() {
    Selector.selectSchedule(context, onSelected: (s) {
      currentSchedule = s;
      Navigator.of(context).pop();
      setState(() {});
    });
  }
}
