import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/trainer_crud.dart';
import 'package:tourist_admin_panel/model/group.dart';

import '../../api/section_api.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../model/trainer.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../section_crud.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({super.key, required this.onSubmit, this.initial});

  final Function(Group) onSubmit;
  final Group? initial;

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  var builder = GroupBuilder();
  var nameController = TextEditingController();
  Section? currentSection;
  Trainer? currentTrainer;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = GroupBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      currentSection = builder.section;
      currentTrainer = builder.trainer;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
              "$actionName group",
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
                        child: Image.asset("assets/images/group.png")),
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
                    child: InputLabel(
                      controller: nameController,
                      hintText: "Group name",
                    ),
                  ),
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
                  Visibility(
                    visible: currentSection != null,
                    child: SizedBox(
                        width: 300,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Image.asset("assets/images/trainer.png"),
                            ),
                            const SizedBox(
                              width: Config.defaultPadding,
                            ),
                            SimpleButton(
                                onPressed: selectTrainer,
                                color: Config.secondaryColor,
                                text: currentTrainer == null
                                    ? "Select trainer"
                                    : "${currentTrainer!.tourist.firstName} ${currentTrainer!.tourist.secondName}")
                          ],
                        )),
                  ),
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
                    if (currentSection == null) {
                      ServiceIO()
                          .showMessage("Section is not selected", context);
                      return;
                    }
                    if (currentTrainer == null) {
                      ServiceIO()
                          .showMessage("Trainer is not selected", context);
                      return;
                    }
                    builder.name = nameController.text;
                    if (builder.name.isEmpty) {
                      ServiceIO()
                          .showMessage("Name must not be empty", context);
                      return;
                    }
                    builder.section = currentSection!;
                    builder.trainer = currentTrainer!;
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
                  currentTrainer = null;
                  Navigator.of(context).pop();
                  setState(() {});
                },
                filtersFlex: 1,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  void selectTrainer() {
    if (currentSection == null) {
      ServiceIO().showMessage("Select section first", context);
      return;
    }
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: BaseCRUDFutureBuilder<Trainer>(
              itemsGetter: TrainerApi().findBySectionId(currentSection!.id),
              contentBuilder: (trainers) => TrainerCRUD(
                trainers: trainers,
                modifiable: false,
                onTap: (s) {
                  currentTrainer = s;
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
}
