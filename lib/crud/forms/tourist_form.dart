import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/group_api.dart';
import '../../components/image_button.dart';
import '../../components/input_label.dart';
import '../../components/simple_button.dart';
import '../../config/config.dart';
import '../../model/group.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../group_crud.dart';

class TouristForm extends StatefulWidget {
  const TouristForm({super.key, required this.onSubmit, this.initial});

  final Function(Tourist) onSubmit;
  final Tourist? initial;

  @override
  State<TouristForm> createState() => _TouristFormState();
}

class _TouristFormState extends State<TouristForm> {
  var builder = TouristBuilder();
  var firstNameController = TextEditingController();
  var secondNameController = TextEditingController();
  static const defaultBirthYear = 2000;
  Group? currentGroup;

  String get postfix => builder.gender == Gender.male ? "_male" : "_female";

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = TouristBuilder.fromExisting(widget.initial!);
      firstNameController.text = builder.firstName;
      secondNameController.text = builder.secondName;
      currentGroup = builder.group;
      return;
    }
    builder.gender = Gender.male;
    builder.skillCategory = SkillCategory.beginner;
    builder.birthYear = defaultBirthYear;
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: 'tourist',
        formType: widget.initial == null ? FormType.create : FormType.update,
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBox(imageName: "tourist$postfix.png"),
                const SizedBox(
                  width: Config.defaultPadding,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ToggleSwitch(
                        minWidth: 100.0,
                        initialLabelIndex: builder.gender.index,
                        cornerRadius: Config.defaultRadius,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Config.secondaryColor,
                        inactiveFgColor: Colors.white,
                        animate: true,
                        animationDuration: 200,
                        totalSwitches: 2,
                        labels: const ['Male', 'Female'],
                        icons: const [Icons.male, Icons.female],
                        activeBgColors: const [
                          [Colors.blue],
                          [Colors.pink]
                        ],
                        customTextStyles: [
                          Config.defaultTextStyle(),
                          Config.defaultTextStyle(),
                        ],
                        onToggle: (index) {
                          if (index == null) return;
                          setState(() {
                            builder.gender = Gender.values[index];
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    SizedBox(
                        width: BaseForm.defaultLabelWidth,
                        child: InputLabel(
                            controller: firstNameController,
                            hintText: "First name")),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    SizedBox(
                        width: BaseForm.defaultLabelWidth,
                        child: InputLabel(
                            controller: secondNameController,
                            hintText: "Second name")),
                    const SizedBox(
                      height: Config.defaultPadding,
                    ),
                    Row(
                      children: [
                        ImageButton(
                            onPressed: selectGroup,
                            imageName: "group.png",
                            text: currentGroup == null
                                ? "Select group"
                                : currentGroup!.name),
                        Visibility(
                          visible: currentGroup != null,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  currentGroup = null;
                                });
                              },
                              tooltip: "Unselect group",
                              icon: const Icon(
                                Icons.delete,
                                size: 25,
                                color: Colors.redAccent,
                              )),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: Config.defaultPadding,
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ToggleSwitch(
                minWidth: 150.0,
                initialLabelIndex: builder.skillCategory.index,
                cornerRadius: Config.defaultRadius,
                activeFgColor: Colors.black,
                inactiveBgColor: Config.secondaryColor,
                inactiveFgColor: Colors.white,
                totalSwitches: 3,
                animate: true,
                animationDuration: 200,
                labels: const ['Beginner', 'Intermediate', 'Advanced'],
                activeBgColors: const [
                  [Colors.green],
                  [Colors.deepOrangeAccent],
                  [Colors.red]
                ],
                customTextStyles: [
                  Config.defaultTextStyle(),
                  Config.defaultTextStyle(),
                  Config.defaultTextStyle(),
                ],
                onToggle: (index) {
                  if (index == null) return;
                  setState(() {
                    builder.skillCategory = SkillCategory.values[index];
                  });
                },
              ),
            ),
            const SizedBox(
              height: Config.defaultPadding * 2,
            ),
            Container(
              alignment: Alignment.center,
              child: Config.defaultText("Select birth year"),
            ),
            SizedBox(
              height: Config.pageHeight(context) * .2,
              width: 500,
              child: YearPicker(
                  firstDate: DateTime(1940),
                  lastDate: DateTime(2010),
                  selectedDate: DateTime(builder.birthYear),
                  currentDate: DateTime(builder.birthYear),
                  onChanged: (date) {
                    setState(() {
                      builder.birthYear = date.year;
                    });
                  }),
            )
          ],
        ));
  }

  void buildEntity() {
    builder.group = currentGroup;
    builder.firstName = firstNameController.text;
    builder.secondName = secondNameController.text;
    if (builder.firstName.isEmpty) {
      ServiceIO().showMessage("First name must not be empty", context);
      return;
    }
    if (builder.secondName.isEmpty) {
      ServiceIO().showMessage("Second name must not be empty", context);
      return;
    }
    widget.onSubmit(builder.build());
  }

  void selectGroup() {
    Selector.selectGroup(context, onSelected: (s) {
      Navigator.of(context).pop();
      setState(() {
        currentGroup = s;
      });
    });
  }
}
