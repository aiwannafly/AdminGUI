import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_select_list.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../api/schedule_api.dart';
import '../../config/config.dart';
import '../../model/activity.dart';
import '../../model/schedule.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../schedule_crud.dart';

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
    return Container(
      width: 700,
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
              "$actionName activity",
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
                        child: Image.asset("assets/images/activity.png")),
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
                      width: 350,
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
                              onPressed: selectSchedule,
                              color: Config.secondaryColor,
                              text: currentSchedule == null
                                  ? "Select schedule"
                                  : "${currentSchedule!.group.name} ${currentSchedule!.dayOfWeek.string} ${timeOfDayToStr(currentSchedule!.timeOfDay)}")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 350,
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
                              onPressed: selectDate,
                              color: Config.secondaryColor,
                              text: dateTimeToStr(builder.date))
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                ],
              )
            ],
          ),
          currentSchedule != null
              ? Column(
                  children: [
                    Config.defaultText("Mark attendance"),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    ItemsFutureBuilder<Tourist>(
                        contentBuilder: buildTouristsSelector,
                        itemsGetter: TouristApi()
                            .findByGroup(groupId: currentSchedule!.group.id)),
                  ],
                )
              : const SizedBox(),
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
                    if (currentSchedule == null) {
                      ServiceIO()
                          .showMessage("Schedule is not selected", context);
                      return;
                    }
                    builder.attended = attended.toList();
                    builder.schedule = currentSchedule!;
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

  Widget buildTouristsSelector(List<Tourist> tourists) {
    return TouristSelectList(
      tourists: tourists,
      filtersFlex: 0,
      modifiable: false,
      hideFilters: true,
      itemHoverColor: Colors.grey,
      selected: attended,
    );
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: builder.date,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (newTime != null) {
      setState(() {
        builder.date = newTime;
      });
    }
  }

  void selectSchedule() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
            width: max(900, Config.pageWidth(context) * .5),
            height: max(400, Config.pageHeight(context) * .5),
            color: Config.bgColor.withOpacity(.99),
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Schedule>(
              itemsGetter: ScheduleApi().getAll(),
              contentBuilder: (items) => ScheduleCRUD(
                items: items,
                onTap: (s) {
                  currentSchedule = s;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 1,
                itemHoverColor: Colors.grey,
              ),
            )));
  }
}
