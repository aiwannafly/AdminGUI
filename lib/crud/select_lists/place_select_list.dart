import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/forms/place_form.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/place.dart';

import '../../api/place_api.dart';
import '../../components/check_box.dart';
import '../../config/config.dart';

class PlaceSelectList extends StatefulWidget {
  const PlaceSelectList(
      {super.key,
        required this.places,
        required this.filtersFlex,
        this.itemHoverColor,
        this.onDispose,
        this.hideFilters = false,
        this.modifiable = true,
        required this.selected});

  final Color? itemHoverColor;
  final int filtersFlex;
  final List<Place> places;
  final Set<Place> selected;
  final VoidCallback? onDispose;
  final bool hideFilters;
  final bool modifiable;

  @override
  State<PlaceSelectList> createState() => _PlaceSelectListState();
}

class _PlaceSelectListState extends State<PlaceSelectList> {
  List<Place> get places => widget.places;

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseCrud<Place>(
        title: "Select places",
        items: places,
        modifiable: widget.modifiable,
        columns: [
          ColumnData<Place>(
              name: "Select",
              buildColumnElem: (e) =>
                  CheckBox(item: e, selected: widget.selected),
              flex: 1),
          ColumnData<Place>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<Place>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 3),
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
        crudApi: PlaceApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder({required Function(Place) onSubmit, Place? initial}) {
    return PlaceForm(
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
      child: Container(),
    );
  }
}
