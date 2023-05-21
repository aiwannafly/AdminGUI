import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/skill.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_form.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';

import '../api/tourist_api.dart';
import '../model/tourist.dart';
import '../services/service_io.dart';

class TouristCRUD extends StatefulWidget {
  const TouristCRUD({super.key, required this.tourists,
  this.onTap, required this.filtersFlex, this.itemHoverColor});

  final void Function(Tourist)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;
  final List<Tourist> tourists;

  @override
  State<TouristCRUD> createState() => _TouristCRUDState();
}

class _TouristCRUDState extends State<TouristCRUD> {
  List<Tourist> get tourists => widget.tourists;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Tourist>(
        title: "Registered tourists",
        items: tourists,
        columns: [
          ColumnData<Tourist>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Tourist>(
              name: "Name",
              buildColumnElem: (e) => centeredText('${e.firstName} ${e.secondName}'),
              flex: 3),
          ColumnData<Tourist>(
              name: "Group",
              buildColumnElem: (e) => centeredText(e.group != null ? e.group!.name : "-"),
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
    return TouristForm(onSubmit: onSubmit, initial: initial,);
  }

  Widget centeredText(String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget buildFilters() {
    return Expanded(
      flex: widget.filtersFlex,
      child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: TouristFilters(
            onChange: getFiltered,
          )),
    );
  }

  void getFiltered(
      Set<Gender> genders, Set<SkillCategory> skillCategories) async {
    List<Tourist>? filtered =
        await TouristApi().findByGenderAndSkill(genders, skillCategories);
    if (filtered == null) {
      await Future.microtask(() {
        ServiceIO()
            .showMessage("Could not search for these tourists :/", context);
      });
      return;
    }
    setState(() {
      tourists.clear();
      tourists.addAll(filtered);
    });
  }

}
