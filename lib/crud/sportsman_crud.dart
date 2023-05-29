import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/skill.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/sportsman.dart';

import '../api/sportsman_api.dart';
import '../config/config.dart';
import 'forms/sportsman_form.dart';

class SportsmanCRUD extends StatefulWidget {
  const SportsmanCRUD(
      {super.key,
        required this.sportsmen,
        this.onTap,
        required this.filtersFlex,
        this.itemHoverColor});

  final void Function(Sportsman)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;
  final List<Sportsman> sportsmen;

  @override
  State<SportsmanCRUD> createState() => _SportsmanCRUDState();
}

class _SportsmanCRUDState extends State<SportsmanCRUD> {
  final titleNotifier = ValueNotifier("All sportsmen");

  List<Sportsman> get sportsmen => widget.sportsmen;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Sportsman>(
        title: titleNotifier.value,
        titleNotifier: titleNotifier,
        items: sportsmen,
        columns: [
          ColumnData<Sportsman>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Sportsman>(
              name: "Name",
              buildColumnElem: (e) =>
                  centeredText('${e.tourist.firstName} ${e.tourist.secondName}'),
              flex: 3),
          ColumnData<Sportsman>(
              name: "Group",
              buildColumnElem: (e) =>
                  centeredText(e.tourist.group != null ? e.tourist.group!.name : "-"),
              flex: 2),
          ColumnData<Sportsman>(
              name: "Skill category",
              buildColumnElem: (e) => SkillView(skillCategory: e.tourist.skillCategory),
              flex: 3),
          ColumnData<Sportsman>(
              name: "Gender",
              buildColumnElem: (e) => GenderView(gender: e.tourist.gender),
              flex: 2),
          ColumnData<Sportsman>(
              name: "Birth year",
              buildColumnElem: (e) => centeredText('${e.tourist.birthYear}'),
              flex: 2),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: SportsmanApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Sportsman) onSubmit, Sportsman? initial}) {
    return SportsmanForm(
      onSubmit: onSubmit,
      initial: initial,
    );
  }

  Widget buildFilters() {
    if (widget.filtersFlex == 0) return const SizedBox();
    return Flexible(
      flex: widget.filtersFlex,
      child: Container(),
    );
  }
}
