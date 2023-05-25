import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/input_label.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/trainer_crud.dart';
import 'package:tourist_admin_panel/model/group.dart';

import '../../api/section_api.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../model/trainer.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../section_crud.dart';
import '../selector.dart';

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
      currentSection = builder.trainer.section;
      currentTrainer = builder.trainer;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
      buildEntity: buildEntity,
      entityName: "group",
      formType: widget.initial == null ? FormType.create : FormType.update,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImageBox(imageName: "group.png"),
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
                width: BaseForm.defaultLabelWidth,
                child: InputLabel(
                  controller: nameController,
                  hintText: "Group name",
                ),
              ),
              const SizedBox(
                height: Config.defaultPadding,
              ),
              ImageButton(
                  onPressed: selectSection,
                  text: currentSection == null
                      ? "Select section"
                      : currentSection!.name,
                  imageName: "section.png"),
              const SizedBox(
                height: Config.defaultPadding,
              ),
              Visibility(
                visible: currentSection != null,
                child: ImageButton(
                    onPressed: selectTrainer,
                    text: currentTrainer == null
                        ? "Select trainer"
                        : "${currentTrainer!.tourist.firstName} ${currentTrainer!.tourist.secondName}",
                    imageName: "trainer.png"),
              ),
              const SizedBox(
                height: Config.defaultPadding,
              ),
            ],
          )
        ],
      ),
    );
  }

  void buildEntity() {
    if (currentSection == null) {
      ServiceIO().showMessage("Section is not selected", context);
      return;
    }
    if (currentTrainer == null) {
      ServiceIO().showMessage("Trainer is not selected", context);
      return;
    }
    builder.name = nameController.text;
    if (builder.name.isEmpty) {
      ServiceIO().showMessage("Name must not be empty", context);
      return;
    }
    builder.trainer = currentTrainer!;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  void selectSection() {
    Selector.selectSection(context, onSelected: (s) {
      Navigator.of(context).pop();
      setState(() {
        currentSection = s;
      });
    });
  }

  void selectTrainer() {
    if (currentSection == null) {
      ServiceIO().showMessage("Select section first", context);
      return;
    }
    Selector.selectTrainerBySection(context, onSelected: (s) {
      Navigator.of(context).pop();
      setState(() {
        currentTrainer = s;
      });
    }, section: currentSection!);
  }
}
