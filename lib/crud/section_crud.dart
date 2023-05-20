import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/forms/section_form.dart';

import '../api/section_api.dart';
import '../model/section.dart';

class SectionCRUD extends StatefulWidget {
  const SectionCRUD(
      {super.key,
      required this.sections,
      required this.onTap,
      this.itemHoverColor,
      required this.filtersFlex});

  final List<Section> sections;
  final void Function(Section) onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<SectionCRUD> createState() => _SectionCRUDState();
}

class _SectionCRUDState extends State<SectionCRUD> {
  List<Section> get sections => widget.sections;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Section>(
        title: "Sections",
        items: sections,
        columns: [
          ColumnData<Section>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Section>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 3),
          ColumnData<Section>(
              name: "Manager",
              buildColumnElem: (e) => centeredText('${e.sectionManager.firstName} ${e.sectionManager.secondName}'),
              flex: 3),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: SectionApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Section) onSubmit, Section? initial}) {
    return SectionForm(
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
    return Expanded(flex: widget.filtersFlex, child: Container());
  }
}
