import 'dart:math';

import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/group_api.dart';
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

  String get postfix =>
      builder.gender == Gender.male ? "_male.png" : "_female.png";

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
    return Container(
      height: 650,
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
              "$actionName tourist",
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
                        child: Image.asset("assets/images/tourist$postfix")),
                  )),
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
                      width: 300,
                      child: InputLabel(
                          controller: firstNameController,
                          hintText: "First name")),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: InputLabel(
                          controller: secondNameController,
                          hintText: "Second name")),
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
                      )),
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
          ),
          const SizedBox(
            height: Config.defaultPadding * 2,
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
                    builder.group = currentGroup;
                    builder.firstName = firstNameController.text;
                    builder.secondName = secondNameController.text;
                    if (builder.firstName.isEmpty) {
                      ServiceIO()
                          .showMessage("First name must not be empty", context);
                      return;
                    }
                    if (builder.secondName.isEmpty) {
                      ServiceIO().showMessage(
                          "Second name must not be empty", context);
                      return;
                    }
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
                filtersFlex: 1,
                itemHoverColor: Colors.grey,
              ),
            )));
  }
}
