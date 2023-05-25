import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../api/group_api.dart';
import '../../components/image_button.dart';
import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/schedule.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../group_crud.dart';

class ScheduleForm extends StatefulWidget {
  const ScheduleForm({super.key, required this.onSubmit, this.initial});

  final Function(Schedule) onSubmit;
  final Schedule? initial;

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  var builder = ScheduleBuilder();
  Group? currentGroup;
  final durationNotifier = ValueNotifier(defaultActivityDurationMins);

  @override
  void initState() {
    super.initState();
    durationNotifier.addListener(updateDuration);
    if (widget.initial != null) {
      builder = ScheduleBuilder.fromExisting(widget.initial!);
      currentGroup = builder.group;
      if (builder.durationMins == 0) {
        builder.durationMins = defaultActivityDurationMins;
      }
      durationNotifier.value = builder.durationMins;
      return;
    }
    builder.id = 0;
    builder.dayOfWeek = DayOfWeek.monday;
    builder.durationMins = defaultActivityDurationMins;
    builder.timeOfDay = const TimeOfDay(hour: 9, minute: 0);
  }

  @override
  void dispose() {
    super.dispose();
    durationNotifier.removeListener(updateDuration);
  }

  void updateDuration() {
    builder.durationMins = durationNotifier.value;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "schedule",
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageBox(imageName: "schedule.png"),
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
                        onPressed: selectGroup,
                        imageName: "group.png",
                        text: currentGroup == null
                            ? "Select group"
                            : currentGroup!.name),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectTime,
                        imageName: "time.png",
                        text: timeOfDayToStr(builder.timeOfDay)),
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
                              child:
                                  Image.asset("assets/images/day_of_week.png"),
                            ),
                            const SizedBox(
                              width: Config.defaultPadding,
                            ),
                            DropdownMenu(
                                onSelected: (val) {
                                  if (val != null) {
                                    setState(() {
                                      builder.dayOfWeek = val;
                                    });
                                  }
                                },
                                menuStyle: MenuStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Config.secondaryColor),
                                  // side: MaterialStateProperty.all(const BorderSide(width: 0))
                                ),
                                initialSelection: builder.dayOfWeek,
                                dropdownMenuEntries: DayOfWeek.values
                                    .map((e) => DropdownMenuEntry(
                                        value: e, label: e.string))
                                    .toList())
                          ],
                        )),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: Config.defaultPadding,
            ),
            SizedBox(
              width: 400,
              child: SliderTextSetter<int>(
                  minVal: minActivityDurationMins,
                  maxVal: maxActivityDurationMins,
                  divisions:
                      (maxActivityDurationMins - minActivityDurationMins) ~/
                          durationPortion,
                  notifier: durationNotifier,
                  leading: "Select activity duration"),
            )
          ],
        ));
  }

  void buildEntity() {
    if (currentGroup == null) {
      ServiceIO().showMessage("Group is not selected", context);
      return;
    }
    builder.group = currentGroup!;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  void selectTime() async {
    TimeOfDay? newTime =
        await showTimePicker(context: context, initialTime: builder.timeOfDay);
    if (newTime != null) {
      setState(() {
        builder.timeOfDay = newTime;
      });
    }
  }

  void selectGroup() {
    Selector.selectGroup(context, onSelected: (g) {
      Navigator.of(context).pop();
      setState(() {
        currentGroup = g;
      });
    });
  }
}
