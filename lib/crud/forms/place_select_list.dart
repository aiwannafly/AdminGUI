import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/forms/place_form.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/model/place.dart';

import '../../api/place_api.dart';
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
                  PlaceCheckBox(place: e, selected: widget.selected),
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

class PlaceCheckBox extends StatefulWidget {
  const PlaceCheckBox(
      {super.key, required this.place, required this.selected});

  final Place place;
  final Set<Place> selected;

  @override
  State<PlaceCheckBox> createState() => _PlaceCheckBoxState();
}

class _PlaceCheckBoxState extends State<PlaceCheckBox> {
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
      value: widget.selected.contains(widget.place),
      onChanged: (bool? selected) {
        if (selected == null) return;
        setState(() {
          if (selected) {
            widget.selected.add(widget.place);
          } else {
            widget.selected.remove(widget.place);
          }
        });
      },
    );
  }
}
