import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';
import 'package:tourist_admin_panel/services/service_io.dart';

import '../../components/image_box.dart';
import '../../components/image_button.dart';
import '../../config/config.dart';
import '../../model/trainer.dart';
import '../../utils.dart';
import '../selector.dart';

class TrainerWorkHours extends StatefulWidget {
  const TrainerWorkHours({super.key});

  @override
  State<TrainerWorkHours> createState() => _TrainerWorkHoursState();
}

class _TrainerWorkHoursState extends State<TrainerWorkHours> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Trainer? selectedTrainer;
  int? workHours;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Config.defaultText(
            "Get trainer work hours",
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
                    Config.defaultText("Trainer      "),
                    const SizedBox(
                      width: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: selectTrainer,
                        text: selectedTrainer == null
                            ? "Select trainer"
                            : "${selectedTrainer!.tourist.firstName} ${selectedTrainer!.tourist.secondName}",
                        imageName: "trainer.png"),
                  ],
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Row(
                  children: [
                    Config.defaultText("Start date  "),
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
                    Config.defaultText("End date    "),
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
                Row(
                  children: [
                    Config.defaultText("Work hours"),
                    const SizedBox(
                      width: Config.defaultPadding,
                    ),
                    ImageButton(
                        onPressed: getWorkHours,
                        color: workHours == null
                            ? Colors.green
                            : Config.secondaryColor,
                        imageName: "time.png",
                        text: workHours == null ? "Get" : "${workHours!}"),
                  ],
                ),
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

  void selectTrainer() {
    Selector.selectTrainer(context, onSelected: (g) {
      Navigator.of(context).pop();
      setState(() {
        selectedTrainer = g;
        workHours = null;
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
        workHours = null;
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
        workHours = null;
      });
    });
  }

  void getWorkHours() async {
    if (selectedTrainer == null) {
      ServiceIO().showMessage("Select trainer first", context);
      return;
    }
    int? res = await TrainerApi().getWorkHours(
        trainerId: selectedTrainer!.id, startDate: startDate, endDate: endDate);
    if (res == null) {
      Future.microtask(() => ServiceIO().showMessage("Failed to get response from server :/", context));
      return;
    }
    setState(() {
      workHours = res;
    });
  }
}
