import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/competition.dart';
import 'package:tourist_admin_panel/utils.dart';

import '../api/competition_api.dart';
import 'forms/competition_form.dart';

class CompetitionCRUD extends StatefulWidget {
  const CompetitionCRUD(
      {super.key,
        required this.items,
        this.onTap,
        this.itemHoverColor,
        required this.filtersFlex});

  final List<Competition> items;
  final void Function(Competition)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<CompetitionCRUD> createState() => _CompetitionCRUDState();
}

class _CompetitionCRUDState extends State<CompetitionCRUD> {
  List<Competition> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Competition>(
        title: "Competitions",
        items: items,
        columns: [
          ColumnData<Competition>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Competition>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 2),
          ColumnData<Competition>(
              name: "Date",
              buildColumnElem: (e) => centeredText(dateTimeToStr(e.date)),
              flex: 2)
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: CompetitionApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder(
      {required Function(Competition) onSubmit, Competition? initial}) {
    return CompetitionForm(onSubmit: onSubmit, initial: initial);
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

