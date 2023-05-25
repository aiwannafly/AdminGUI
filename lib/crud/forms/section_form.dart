import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

import '../../api/section_manager_api.dart';
import '../../components/input_label.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../section_manager_crud.dart';
import '../selector.dart';

class SectionForm extends StatefulWidget {
  const SectionForm({super.key, required this.onSubmit, this.initial});

  final Function(Section) onSubmit;
  final Section? initial;

  @override
  State<SectionForm> createState() => _SectionFormState();
}

class _SectionFormState extends State<SectionForm> {
  var builder = SectionBuilder();
  var nameController = TextEditingController();
  SectionManager? currentManager;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = SectionBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      currentManager = builder.sectionManager;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "section",
        formType: widget.initial == null ? FormType.create : FormType.update,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ImageBox(imageName: "section.png"),
            const SizedBox(
              width: Config.defaultPadding,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: Config.defaultPadding * 3,
                ),
                ImageButton(
                    onPressed: selectManager,
                    text: currentManager == null
                        ? "Select section manager"
                        : "${currentManager!.firstName} ${currentManager!.secondName}",
                    imageName: "manager.png"),
                const SizedBox(
                  height: Config.defaultPadding * 2,
                ),
                SizedBox(
                    width: BaseForm.defaultLabelWidth,
                    child: InputLabel(
                        controller: nameController, hintText: "Section name")),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
              ],
            )
          ],
        ));
  }

  void buildEntity() {
    builder.name = nameController.text;
    if (builder.name.isEmpty) {
      ServiceIO().showMessage("Name must not be empty", context);
      return;
    }
    if (currentManager == null) {
      ServiceIO().showMessage("Section manager is not selected", context);
      return;
    }
    builder.sectionManager = currentManager!;
    Navigator.of(context).pop();
    widget.onSubmit(builder.build());
  }

  void selectManager() {
    Selector.selectManager(context, onSelected: (s) {
      Navigator.of(context).pop();
      setState(() {
        currentManager = s;
      });
    });
  }
}
