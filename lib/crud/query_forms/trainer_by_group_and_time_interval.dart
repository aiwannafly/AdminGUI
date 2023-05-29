import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/services/service_io.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../../config/config.dart';
import '../../model/trainer.dart';

class TrainerByGroupAndTimeInterval extends StatefulWidget {
  const TrainerByGroupAndTimeInterval({super.key, required this.onFound});

  final void Function(List<Trainer> trainers) onFound;

  @override
  State<TrainerByGroupAndTimeInterval> createState() =>
      _TrainerByGroupAndTimeIntervalState();
}

class _TrainerByGroupAndTimeIntervalState
    extends State<TrainerByGroupAndTimeInterval> {
  Group? selectedGroup;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Config.defaultText(
            "Find trainers, who had activities with a chosen group\nin a selected time period",
            22),
        const SizedBox(
          height: Config.defaultPadding * 2,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageBox(
              imageName: "trainer.png",
              areaSize: 180,
              imageSize: 130,
            ),
            const SizedBox(
              width: Config.defaultPadding * 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Row(
                  children: [
                    Config.defaultText("Group     "),
                    const SizedBox(
                      width: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectGroup,
                        text: selectedGroup == null
                            ? "Select group"
                            : selectedGroup!.name,
                        imageName: "group.png"),
                  ],
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Row(
                  children: [
                    Config.defaultText("Start date"),
                    const SizedBox(
                      width: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectStartDate,
                        text: dateTimeToStr(startDate),
                        imageName: "schedule.png"),
                  ],
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Row(
                  children: [
                    Config.defaultText("End date  "),
                    const SizedBox(
                      width: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectEndDate,
                        text: dateTimeToStr(endDate),
                        imageName: "schedule.png"),
                  ],
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      SimpleButton(
                          onPressed: find, color: Colors.green, text: "Find"),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        const SizedBox(
          width: Config.defaultPadding * 2,
        ),
      ],
    );
  }

  void selectGroup() {
    Selector.selectGroup(context, onSelected: (g) {
      Navigator.of(context).pop();
      setState(() {
        selectedGroup = g;
      });
    });
  }

  void selectStartDate() {
    Selector.selectDate(context,
        initialDate: endDate,
        firstDate: endDate.subtract(const Duration(days: 300)),
        lastDate: endDate, onSelected: (d) {
      setState(() {
        startDate = d;
      });
    });
  }

  void selectEndDate() {
    Selector.selectDate(context,
        initialDate: startDate,
        firstDate: startDate,
        lastDate: startDate.add(const Duration(days: 300)), onSelected: (d) {
      setState(() {
        endDate = d;
      });
    });
  }

  void find() async {
    if (selectedGroup == null) {
      ServiceIO().showMessage("Select group", context);
      return;
    }
    List<Trainer>? res = await TrainerApi().findByGroupAndPeriod(
        groupId: selectedGroup!.id, startDate: startDate, endDate: endDate);
    if (res == null) {
      Future.microtask(() => ServiceIO()
          .showMessage("Failed to get response from server :/", context));
      return;
    }
    Future.microtask(() => Navigator.of(context).pop())
        .then((value) => widget.onFound(res));
  }
}
