import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/components/image_button.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/select_lists/tourist_select_list.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/competition.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/tourist_api.dart';
import '../../components/input_label.dart';
import '../../config/config.dart';
import '../../services/service_io.dart';
import '../../utils.dart';
import '../base_crud_future_builder.dart';

class CompetitionForm extends StatefulWidget {
  const CompetitionForm({super.key, required this.onSubmit, this.initial});

  final Function(Competition) onSubmit;
  final Competition? initial;

  @override
  State<CompetitionForm> createState() => _CompetitionFormState();
}

class _CompetitionFormState extends State<CompetitionForm> {
  var builder = CompetitionBuilder();
  Set<Tourist> selected = HashSet();
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = CompetitionBuilder.fromExisting(widget.initial!);
      selected.addAll(builder.tourists);
      nameController.text = builder.name;
      return;
    }
    builder.id = 0;
    builder.date = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
      buildEntity: buildEntity,
      entityName: "competition",
      formType: widget.initial == null ? FormType.create : FormType.update,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ImageBox(imageName: "competition.png"),
          const SizedBox(
            width: Config.defaultPadding * 3,
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
                  hintText: "Competition name",
                ),
              ),
              const SizedBox(
                height: Config.defaultPadding,
              ),
              ImageButton(
                  onPressed: selectTourists,
                  text: selected.isEmpty
                      ? "Select participants"
                      : "Selected ${selected.length} participants",
                  imageName: "group.png"),
              const SizedBox(
                height: Config.defaultPadding,
              ),
              ImageButton(
                  onPressed: selectDate,
                  text: "Start date ${dateTimeToStr(builder.date)}",
                  imageName: "time.png"),
              const SizedBox(
                height: Config.defaultPadding,
              )
            ],
          )
        ],
      ),
    );
  }

  void buildEntity() {
    builder.tourists = selected.toList();
    if (builder.tourists.isEmpty) {
      ServiceIO().showMessage("Select participants", context);
      return;
    }
    builder.name = nameController.text;
    if (builder.name.isEmpty) {
      ServiceIO().showMessage("Name must not be empty", context);
      return;
    }
    widget.onSubmit(builder.build());
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: builder.date,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (newTime != null) {
      setState(() {
        builder.date = newTime;
      });
    }
  }

  void selectTourists() {
    Selector.selectTouristsFromTrainersAndSportsmen(context, selected: selected, onDispose: () {
      Future.delayed(const Duration(milliseconds: 10), () {
        setState(() {});
      });
    });
  }
}
