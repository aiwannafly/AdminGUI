import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/forms/trainer_form.dart';
import 'package:tourist_admin_panel/model/trainer.dart';

import '../api/trainer_api.dart';
import '../components/gender.dart';

class TrainerCRUD extends StatefulWidget {
  const TrainerCRUD(
      {super.key,
        required this.trainers,
        required this.onTap,
        this.itemHoverColor,
        required this.filtersFlex});

  final List<Trainer> trainers;
  final void Function(Trainer) onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<TrainerCRUD> createState() => _TrainerCRUDState();
}

class _TrainerCRUDState extends State<TrainerCRUD> {
  List<Trainer> get trainers => widget.trainers;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Trainer>(
        title: "Trainers",
        items: trainers,
        columns: [
          ColumnData<Trainer>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Trainer>(
              name: "First name",
              buildColumnElem: (e) => centeredText(e.tourist.firstName),
              flex: 3),
          ColumnData<Trainer>(
              name: "Second name",
              buildColumnElem: (e) => centeredText(e.tourist.secondName),
              flex: 3),
          ColumnData<Trainer>(
              name: "Gender",
              buildColumnElem: (e) => GenderView(gender: e.tourist.gender),
              flex: 2),
          ColumnData<Trainer>(
              name: "Salary, rub.",
              buildColumnElem: (e) => centeredText(e.salary.toString()),
              flex: 3),
          ColumnData<Trainer>(
              name: "Section",
              buildColumnElem: (e) => centeredText(e.section.name),
              flex: 3),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: TrainerApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Trainer) onSubmit, Trainer? initial}) {
    return TrainerForm(onSubmit: onSubmit, initial: initial);
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
