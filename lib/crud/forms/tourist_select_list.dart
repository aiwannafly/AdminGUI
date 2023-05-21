import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/gender.dart';
import 'package:tourist_admin_panel/components/skill.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_form.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';

import '../../api/tourist_api.dart';
import '../../config/config.dart';
import '../../model/tourist.dart';
import '../../services/service_io.dart';

class TouristSelectList extends StatefulWidget {
  const TouristSelectList(
      {super.key,
      required this.tourists,
      required this.filtersFlex,
      this.itemHoverColor,
        this.onDispose,
        this.hideFilters = false,
        this.modifiable = true,
      required this.selected});

  final Color? itemHoverColor;
  final int filtersFlex;
  final List<Tourist> tourists;
  final Set<Tourist> selected;
  final VoidCallback? onDispose;
  final bool hideFilters;
  final bool modifiable;

  @override
  State<TouristSelectList> createState() => _TouristSelectListState();
}

class _TouristSelectListState extends State<TouristSelectList> {
  List<Tourist> get tourists => widget.tourists;

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Tourist>(
        title: "Select tourists",
        items: tourists,
        modifiable: widget.modifiable,
        columns: [
          ColumnData<Tourist>(
              name: "Select",
              buildColumnElem: (e) =>
                  TouristCheckBox(tourist: e, selected: widget.selected),
              flex: 1),
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
        onTap: (t)  {
          setState(() {
            if (widget.selected.contains(t)) {
              widget.selected.remove(t);
            } else {
              widget.selected.add(t);
            }
          });
        },
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

  Widget centeredText(String text) {
    return Center(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget buildFilters() {
    if (widget.hideFilters) {
      return const SizedBox();
    }
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

class TouristCheckBox extends StatefulWidget {
  const TouristCheckBox(
      {super.key, required this.tourist, required this.selected});

  final Tourist tourist;
  final Set<Tourist> selected;

  @override
  State<TouristCheckBox> createState() => _TouristCheckBoxState();
}

class _TouristCheckBoxState extends State<TouristCheckBox> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.contains(MaterialState.selected)) {
      return Colors.blue;
    }
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Config.secondaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: widget.selected.contains(widget.tourist),
      onChanged: (bool? selected) {
        if (selected == null) return;
        setState(() {
          if (selected) {
            widget.selected.add(widget.tourist);
          } else {
            widget.selected.remove(widget.tourist);
          }
        });
      },
    );
  }
}
