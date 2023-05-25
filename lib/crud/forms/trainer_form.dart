import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/crud/crud_config.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/section_api.dart';
import '../../api/tourist_api.dart';
import '../../components/image_button.dart';
import '../../components/slider_text_setter.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../model/trainer.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../section_crud.dart';
import '../tourist_crud.dart';

class TrainerForm extends StatefulWidget {
  const TrainerForm({super.key, required this.onSubmit, this.initial});

  final Function(Trainer) onSubmit;
  final Trainer? initial;

  @override
  State<TrainerForm> createState() => _TrainerFormState();
}

class _TrainerFormState extends State<TrainerForm> {
  var builder = TrainerBuilder();
  static const defaultSalary = 70000;
  final salaryNotifier = ValueNotifier(defaultSalary);
  Section? currentSection;
  Tourist? currentTourist;

  @override
  void initState() {
    super.initState();
    salaryNotifier.addListener(updateSalary);
    if (widget.initial != null) {
      builder = TrainerBuilder.fromExisting(widget.initial!);
      currentSection = builder.section;
      currentTourist = builder.tourist;
      salaryNotifier.value = builder.salary;
      return;
    }
    builder.id = 0;
    builder.salary = defaultSalary;
  }

  @override
  void dispose() {
    super.dispose();
    salaryNotifier.removeListener(updateSalary);
  }

  void updateSalary() {
    builder.salary = salaryNotifier.value;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  String get postfix => currentTourist == null
      ? "_male"
      : currentTourist!.gender == Gender.male
          ? "_male"
          : "_female";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "trainer",
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageBox(imageName: "trainer.png"),
                const SizedBox(
                  width: Config.defaultPadding,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: Config.defaultPadding * 3,
                  ),
                  ImageButton(
                      onPressed: selectTourist,
                      imageName: "tourist$postfix.png",
                      text: currentTourist == null
                          ? "Select person"
                          : "${currentTourist!.firstName} ${currentTourist!.secondName}"),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  ImageButton(
                      onPressed: selectSection,
                      imageName: "section.png",
                      text: currentSection == null
                          ? "Select section"
                          : currentSection!.name)
                ])
              ],
            ),
            SliderTextSetter<int>(
                minVal: minTrainerSalary,
                maxVal: maxTrainerSalary,
                divisions:
                    (maxTrainerSalary - minTrainerSalary) ~/ salaryPortion,
                notifier: salaryNotifier,
                leading: "Select salary")
          ],
        ));
  }

  void buildEntity() {
    if (currentTourist == null) {
      ServiceIO().showMessage("Tourist is not selected", context);
      return;
    }
    if (currentSection == null) {
      ServiceIO().showMessage("Section is not selected", context);
      return;
    }
    builder.section = currentSection!;
    builder.tourist = currentTourist!;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  void selectTourist() {
    Selector.selectTourist(context, onSelected: (t) {
      Navigator.of(context).pop();
      setState(() {
        currentTourist = t;
      });
    });
  }

  void selectSection() {
    Selector.selectSection(context, onSelected: (t) {
      Navigator.of(context).pop();
      setState(() {
        currentSection = t;
      });
    });
  }
}
