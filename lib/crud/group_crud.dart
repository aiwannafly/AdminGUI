import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';

import '../api/group_api.dart';
import '../model/group.dart';
import 'forms/group_form.dart';

class GroupCRUD extends StatefulWidget {
  const GroupCRUD(
      {super.key,
        required this.items,
        this.onTap,
        this.itemHoverColor,
        required this.filtersFlex});

  final List<Group> items;
  final void Function(Group)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<GroupCRUD> createState() => _GroupCRUDState();
}

class _GroupCRUDState extends State<GroupCRUD> {
  List<Group> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Group>(
        title: "Groups",
        items: items,
        columns: [
          ColumnData<Group>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Group>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 3),
          ColumnData<Group>(
              name: "Trainer",
              buildColumnElem: (e) => centeredText('${e.trainer.tourist.firstName} ${e.trainer.tourist.secondName}'),
              flex: 4),
          ColumnData<Group>(
              name: "Section",
              buildColumnElem: (e) => centeredText(e.trainer.section.name),
              flex: 3),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: GroupApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Group) onSubmit, Group? initial}) {
    return GroupForm(
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
    if (widget.filtersFlex == 0) return const SizedBox();
    return Flexible(flex: widget.filtersFlex, child: Container());
  }
}
