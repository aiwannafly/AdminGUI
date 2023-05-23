import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/section_manager_api.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/filters/section_manager_filters.dart';
import 'package:tourist_admin_panel/crud/forms/section_manager_form.dart';

import '../model/section_manager.dart';
import '../services/service_io.dart';

class SectionManagerCRUD extends StatefulWidget {
  const SectionManagerCRUD({super.key, required this.sectionManagers, this.onTap,
  this.itemHoverColor, required this.filtersFlex});

  final List<SectionManager> sectionManagers;
  final void Function(SectionManager)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<SectionManagerCRUD> createState() =>
      _SectionManagerCRUDState();
}

class _SectionManagerCRUDState extends State<SectionManagerCRUD> {
  List<SectionManager> get sectionManagers => widget.sectionManagers;

  @override
  void initState() {
    super.initState();
    SectionManagerFilters.ageRangeNotifier.addListener(getFiltered);
    SectionManagerFilters.salaryRangeNotifier.addListener(getFiltered);
    SectionManagerFilters.employmentYearNotifier.addListener(getFiltered);
  }

  @override
  void dispose() {
    super.dispose();
    SectionManagerFilters.ageRangeNotifier.removeListener(getFiltered);
    SectionManagerFilters.salaryRangeNotifier.removeListener(getFiltered);
    SectionManagerFilters.employmentYearNotifier.removeListener(getFiltered);
  }

  @override
  Widget build(BuildContext context) {
    return BaseCrud<SectionManager>(
        title: "Section managers",
        items: sectionManagers,
        itemHoverColor: widget.itemHoverColor,
        columns: [
          ColumnData<SectionManager>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<SectionManager>(
              name: "Name",
              buildColumnElem: (e) => centeredText('${e.firstName} ${e.secondName}'),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Salary, rub.",
              buildColumnElem: (e) => centeredText('${e.salary}'),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Employm. year",
              buildColumnElem: (e) => centeredText('${e.employmentYear}'),
              flex: 3),
          ColumnData<SectionManager>(
              name: "Birth year",
              buildColumnElem: (e) => centeredText('${e.birthYear}'),
              flex: 3),
        ],
        onTap: widget.onTap,
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
    if (widget.filtersFlex == 0) return const SizedBox();
    return Expanded(
      flex: widget.filtersFlex,
      child: Container(
          margin: const EdgeInsets.only(top: 30),
          child: SectionManagerFilters(
            onChange: getFiltered,
          )),
    );
  }

  void getFiltered() async {
    List<SectionManager>? filtered =
    await SectionManagerApi().findByGenderAndAgeAndSalary();
    if (filtered == null) {
      await Future.microtask(() {
        ServiceIO()
            .showMessage("Could not search for these managers :/", context);
      });
      return;
    }
    setState(() {
      sectionManagers.clear();
      sectionManagers.addAll(filtered);
    });
  }
}
