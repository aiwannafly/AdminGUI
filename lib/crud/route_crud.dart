import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/route_type_view.dart';
import 'package:tourist_admin_panel/crud/base_crud.dart';
import 'package:tourist_admin_panel/crud/filters/route_filters.dart';

import '../api/route_api.dart';
import '../config/config.dart';
import '../model/route.dart';
import 'forms/route_form.dart';

class RouteCRUD extends StatefulWidget {
  const RouteCRUD(
      {super.key,
      required this.items,
      this.onTap,
      this.itemHoverColor,
      required this.filtersFlex});

  final List<RouteTrip> items;
  final void Function(RouteTrip)? onTap;
  final Color? itemHoverColor;
  final int filtersFlex;

  @override
  State<RouteCRUD> createState() => _RouteCRUDState();
}

class _RouteCRUDState extends State<RouteCRUD> {
  List<RouteTrip> get items => widget.items;
  final titleNotifier = ValueNotifier("Routes");

  @override
  Widget build(BuildContext context) {
    return BaseCrud<RouteTrip>(
        title: titleNotifier.value,
        titleNotifier: titleNotifier,
        items: items,
        columns: [
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
        onTap: widget.onTap,
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
