import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/section_api.dart';
import '../../api/tourist_api.dart';
import '../../components/value_setter.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../model/trainer.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../filters/tourist_filters.dart';
import '../section_crud.dart';
import '../tourist_crud_content.dart';

class TrainerForm extends StatefulWidget {
  const TrainerForm({super.key, required this.onSubmit, this.initial});

  final Function(Trainer) onSubmit;
  final Trainer? initial;

  @override
  State<TrainerForm> createState() => _TrainerFormState();
}

class _TrainerFormState extends State<TrainerForm> {
  var builder = TrainerBuilder();
  var nameController = TextEditingController();
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
      ? "_male.png"
      : currentTourist!.gender == Gender.male
          ? "_male.png"
          : "_female.png";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
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
              "$actionName trainer",
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
                        child: Image.asset("assets/images/trainer.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Config.defaultPadding * 3,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/tourist$postfix"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectTourist,
                              color: Config.secondaryColor,
                              text: currentTourist == null
                                  ? "Select tourist"
                                  : "${currentTourist!.firstName} ${currentTourist!.secondName}")
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
                            child: Image.asset("assets/images/section.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectSection,
                              color: Config.secondaryColor,
                              text: currentSection == null
                                  ? "Select section"
                                  : currentSection!.name)
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                ],
              )
            ],
          ),
          SliderTextSetter<int>(
              minVal: 30000,
              maxVal: 250000,
              notifier: salaryNotifier,
              leading: "Select salary"),
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
                    if (currentTourist == null) {
                      ServiceIO()
                          .showMessage("Tourist is not selected", context);
                      return;
                    }
                    if (currentSection == null) {
                      ServiceIO()
                          .showMessage("Section is not selected", context);
                      return;
                    }
                    builder.section = currentSection!;
                    builder.tourist = currentTourist!;
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

  void selectTourist() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: BaseCRUDFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findAll(TouristFilters.selectedGenders,
                  TouristFilters.selectedSkillCategories),
              contentBuilder: (tourists) => TouristCRUD(
                tourists: tourists,
                onTap: (s) {
                  currentTourist = s;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ),
          ),
        ));
  }

  void selectSection() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
            width: max(900, Config.pageWidth(context) * .5),
            height: max(400, Config.pageHeight(context) * .5),
            color: Config.bgColor.withOpacity(.99),
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: BaseCRUDFutureBuilder<Section>(
              itemsGetter: SectionApi().getAll(),
              contentBuilder: (sections) => SectionCRUD(
                sections: sections,
                onTap: (s) {
                  currentSection = s;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 1,
                itemHoverColor: Colors.grey,
              ),
            )));
  }
}
