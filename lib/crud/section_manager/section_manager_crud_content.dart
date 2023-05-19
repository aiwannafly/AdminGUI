import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/section_manager_api.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/forms/section_manager_form.dart';

import '../../model/section_manager.dart';

class SectionManagerCRUDContent extends StatefulWidget {
  const SectionManagerCRUDContent({super.key, required this.sectionManagers});

  final List<SectionManager> sectionManagers;

  @override
  State<SectionManagerCRUDContent> createState() =>
      _SectionManagerCRUDContentState();
}

class _SectionManagerCRUDContentState extends State<SectionManagerCRUDContent> {
  List<SectionManager> get sectionManagers => widget.sectionManagers;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<SectionManager>(
        title: "Section managers",
        items: sectionManagers,
        columns: [
          ColumnData<SectionManager>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<SectionManager>(
              name: "First name",
              buildColumnElem: (e) => centeredText(e.firstName),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Second name",
              buildColumnElem: (e) => centeredText(e.secondName),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Salary, rub.",
              buildColumnElem: (e) => centeredText('${e.salary}'),
              flex: 2),
          ColumnData<SectionManager>(
              name: "Employment year",
              buildColumnElem: (e) => centeredText('${e.employmentYear}'),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Birth year",
              buildColumnElem: (e) => centeredText('${e.birthYear}'),
              flex: 3),
        ],
        onTap: (t) {},
        crudApi: SectionManagerApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(SectionManager) onSubmit, SectionManager? initial}) {
    return SectionManagerForm(onSubmit: onSubmit, initial: initial,);
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
    return Expanded(flex: 1, child: Container());
  }
}
