import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/forms/place_form.dart';

import '../api/place_api.dart';
import '../model/place.dart';

class PlaceCRUD extends StatefulWidget {
  const PlaceCRUD(
      {super.key,
        required this.items,
        this.onTap,
        this.itemHoverColor,
        required this.filtersFlex});

  final List<Place> items;
  final void Function(Place)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<PlaceCRUD> createState() => _PlaceCRUDState();
}

class _PlaceCRUDState extends State<PlaceCRUD> {
  List<Place> get items => widget.items;

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Place>(
        title: "Routes",
        items: items,
        columns: [
          ColumnData<Place>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Place>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 3),
        ],
        onTap: widget.onTap,
        itemHoverColor: widget.itemHoverColor,
        crudApi: PlaceApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Place) onSubmit, Place? initial}) {
    return PlaceForm(onSubmit: onSubmit, initial: initial,);
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
