import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/skill.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_form.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';

import '../api/tourist_api.dart';
import '../config/config.dart';
import '../model/tourist.dart';
import 'filters/instructor_filters.dart';

class InstructorCRUD extends StatefulWidget {
  const InstructorCRUD(
      {super.key,
      required this.tourists,
      this.onTap,
      required this.filtersFlex,
      this.itemHoverColor});

  final void Function(Tourist)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;
  final List<Tourist> tourists;

  @override
  State<InstructorCRUD> createState() => _InstructorCRUDState();
}

class _InstructorCRUDState extends State<InstructorCRUD> {
  final titleNotifier = ValueNotifier("All instructors");

  List<Tourist> get tourists => widget.tourists;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Tourist>(
        title: titleNotifier.value,
        titleNotifier: titleNotifier,
        modifiable: false,
        items: tourists,
        columns: [
          ColumnData<Tourist>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Tourist>(
              name: "Name",
              buildColumnElem: (e) =>
                  centeredText('${e.firstName} ${e.secondName}'),
              flex: 3),
          ColumnData<Tourist>(
              name: "Group",
              buildColumnElem: (e) =>
                  centeredText(e.group != null ? e.group!.name : "-"),
              flex: 2),
          ColumnData<Tourist>(
              name: "Skill category",
              buildColumnElem: (e) => SkillView(skillCategory: e.skillCategory),
              flex: 3),
          ColumnData<Tourist>(
              name: "Gender",
              buildColumnElem: (e) => GenderView(gender: e.gender),
              flex: 2),
          ColumnData<Tourist>(
              name: "Birth year",
              buildColumnElem: (e) => centeredText('${e.birthYear}'),
              flex: 2),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: TouristApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Tourist) onSubmit, Tourist? initial}) {
    return TouristForm(
      onSubmit: onSubmit,
      initial: initial,
    );
  }

  Widget buildFilters() {
    if (widget.filtersFlex == 0) return const SizedBox();
    return Flexible(
      flex: widget.filtersFlex,
      child: InstructorFilters(
        titleNotifier: titleNotifier,
        onUpdate: (newValues) {
          setState(() {
            widget.tourists.clear();
            widget.tourists.addAll(newValues);
          });
        },
      ),
    );
  }
}
