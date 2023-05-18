import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../components/input_label.dart';
import '../../config/config.dart';
import '../../services/service_io.dart';

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

  String get postfix =>
      builder.gender == Gender.male ? "_male.png" : "_female.png";

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = TouristBuilder.fromExisting(widget.initial!);
      firstNameController.text = builder.firstName;
      secondNameController.text = builder.secondName;
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
}
