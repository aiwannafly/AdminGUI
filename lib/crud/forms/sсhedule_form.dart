import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../api/group_api.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = ScheduleBuilder.fromExisting(widget.initial!);
      currentGroup = builder.group;
      return;
    }
    builder.id = 0;
    builder.dayOfWeek = DayOfWeek.monday;
    builder.timeOfDay = const TimeOfDay(hour: 9, minute: 0);
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
              "$actionName schedule",
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
                        child: Image.asset("assets/images/schedule.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding,
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
                            child: Image.asset("assets/images/group.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectGroup,
                              color: Config.secondaryColor,
                              text: currentGroup == null
                                  ? "Select group"
                                  : currentGroup!.name)
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
                              onPressed: selectTime,
                              color: Config.secondaryColor,
                              text: timeOfDayToStr(builder.timeOfDay))
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
                            child: Image.asset("assets/images/day_of_week.png"),
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
                                      value: e,
                                      label: e.string))
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
                    if (currentGroup == null) {
                      ServiceIO().showMessage("Group is not selected", context);
                      return;
                    }
                    builder.group = currentGroup!;
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
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
            width: max(900, Config.pageWidth(context) * .5),
            height: max(400, Config.pageHeight(context) * .5),
            color: Config.bgColor.withOpacity(.99),
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Group>(
              itemsGetter: GroupApi().getAll(),
              contentBuilder: (items) => GroupCRUD(
                items: items,
                onTap: (s) {
                  currentGroup = s;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }
}
