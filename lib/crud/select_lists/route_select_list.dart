import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/check_box.dart';
import 'package:tourist_admin_panel/components/route_type_view.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/filters/route_filters.dart';

import '../../api/route_api.dart';
import '../../model/route.dart';
import '../forms/route_form.dart';

class RouteSelectList extends StatefulWidget {
  const RouteSelectList(
      {super.key,
      required this.items,
      this.itemHoverColor,
      this.onDispose,
      required this.selected,
      required this.filtersFlex});

  final List<RouteTrip> items;
  final Color? itemHoverColor;
  final int filtersFlex;
  final Set<RouteTrip> selected;
  final VoidCallback? onDispose;

  @override
  State<RouteSelectList> createState() => _RouteSelectListState();
}

class _RouteSelectListState extends State<RouteSelectList> {
  List<RouteTrip> get items => widget.items;
  ValueNotifier<String> titleNotifier = ValueNotifier("Select routes");

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseCrud<RouteTrip>(
        title: titleNotifier.value,
        titleNotifier: titleNotifier,
        items: items,
        columns: [
          ColumnData<RouteTrip>(
              name: "Select",
              buildColumnElem: (e) =>
                  CheckBox(item: e, selected: widget.selected),
              flex: 1),
          ColumnData<RouteTrip>(
              name: "ID",
              buildColumnElem: (e) => centeredText(e.id.toString()),
              flex: 1),
          ColumnData<RouteTrip>(
              name: "Name",
              buildColumnElem: (e) => centeredText(e.name),
              flex: 3),
          ColumnData<RouteTrip>(
              name: "Length, km.",
              buildColumnElem: (e) => centeredText(e.lengthKm.toString()),
              flex: 2),
          ColumnData<RouteTrip>(
              name: "Type",
              buildColumnElem: (e) => RouteTypeView(routeType: e.routeType),
              flex: 1)
        ],
        onTap: (e) {
          setState(() {
            if (widget.selected.contains(e)) {
              widget.selected.remove(e);
            } else {
              widget.selected.add(e);
            }
          });
        },
        itemHoverColor: widget.itemHoverColor,
        crudApi: RouteApi(),
        formBuilder: formBuilder,
        filters: buildFilters(),
        tailFlex: 1);
  }

  Widget formBuilder(
      {required Function(RouteTrip) onSubmit, RouteTrip? initial}) {
    return RouteForm(
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
    return Flexible(
        flex: widget.filtersFlex,
        child: RouteFilters(
          titleNotifier: titleNotifier,
          onUpdate: (items) {
            setState(() {
              widget.items.clear();
              widget.items.addAll(items);
            });
          },
        ));
  }
}
