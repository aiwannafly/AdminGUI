import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/conditionable.dart';
import 'package:tourist_admin_panel/model/base_entity.dart';

import '../config/config.dart';
import '../responsive.dart';
import '../services/service_io.dart';

class ColumnData<T> {
  final String name;
  final Widget Function(T) buildColumnElem;
  final int flex;

  ColumnData(
      {required this.name, required this.buildColumnElem, required this.flex});
}

class BaseCrud<T extends BaseEntity> extends StatefulWidget {
  static const double dividerWidth = .1;
  static const tileHeight = 40.0;

  const BaseCrud(
      {super.key,
      required this.title,
      required this.items,
      required this.columns,
      this.onTap,
      required this.filters,
      required this.tailFlex,
      required this.crudApi,
      required this.formBuilder,
      this.modifiable = true,
      this.itemHoverColor,
      this.buildUnderneath});

  final void Function(T)? onTap;
  final String title;
  final Widget Function(T)? buildUnderneath;
  final Widget Function({required Function(T) onSubmit, T? initial})
      formBuilder;
  final CRUDApi<T> crudApi;
  final List<T> items;
  final List<ColumnData<T>> columns;
  final Widget filters;
  final int tailFlex;
  final Color? itemHoverColor;
  final bool modifiable;

  @override
  State<BaseCrud<T>> createState() => _BaseCrudState<T>();
}

class _BaseCrudState<T extends BaseEntity> extends State<BaseCrud<T>> {
  Color get dividerColor => Colors.grey.shade200;
  late final List<ColumnData<T>> columns = widget.columns;

  @override
  void initState() {
    super.initState();
    if (!widget.modifiable) {
      return;
    }
    columns.add(ColumnData(
        name: "",
        buildColumnElem: (t) => PopupMenuButton<int>(
              padding: const EdgeInsets.all(0),
              position: PopupMenuPosition.under,
              color: Config.bgColor,
              splashRadius: Config.defaultRadius * 2,
              tooltip: "",
              itemBuilder: (context) => getTileOptions(context, t),
              icon: Icon(
                Icons.more_vert,
                color: Config.iconColor,
              ),
            ),
        flex: widget.tailFlex));
  }

  List<PopupMenuEntry<int>> getTileOptions(BuildContext context, T item) {
    return <PopupMenuEntry<int>>[
      PopupMenuItem(
        value: 1,
        child: Text(
          "Edit",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () => update(item),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          "Delete",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () => delete(item),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: Config.defaultPadding * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Visibility(
                        visible: widget.modifiable,
                        child: ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: Config.paddingAll,
                          ),
                          onPressed: create,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Padding(
                            padding: Config.paddingAll / 2,
                            child: Text(
                              "Add New",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: Config.defaultPadding * 2),
                  child: columnTitles(),
                ),
                SizedBox(
                  height: widget.itemHoverColor == null
                      ? Config.pageHeight(context) * .7
                      : max(300, Config.pageHeight(context) * .35),
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.only(right: Config.defaultPadding * 2),
                    itemBuilder: (BuildContext context, int index) =>
                        index >= widget.items.length
                            ? const SizedBox()
                            : columnRow(widget.items[index]),
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey.shade600,
                      thickness: BaseCrud.dividerWidth,
                      height: 1,
                    ),
                    itemCount: widget.items.length + 1,
                  ),
                ),
              ],
            ),
          ),
          Responsive(mobile: const SizedBox(), desktop: widget.filters),
        ],
      ),
    );
  }

  Widget columnTitleWrapper(BuildContext context,
      {required Widget child}) {
    return Container(
      color: Config.secondaryColor, // Colors.indigo.withOpacity(.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: dividerColor,
            height: BaseCrud.tileHeight,
            width: BaseCrud.dividerWidth / 2,
          ),
          child,
          Container(
            color: dividerColor,
            height: BaseCrud.tileHeight,
            width: BaseCrud.dividerWidth / 2,
          ),
        ],
      ),
    );
  }

  TextStyle? columnTitleStyle(BuildContext context) {
    return const TextStyle(
        fontFamily: "Montserrat", fontSize: 16, color: Colors.white);
    return Theme.of(context).textTheme.titleMedium;
  }

  Widget columnWrapper(BuildContext context, {required Widget child}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          color: dividerColor,
          height: BaseCrud.tileHeight,
          width: BaseCrud.dividerWidth / 2,
        ),
        child,
        Container(
          color: dividerColor,
          height: BaseCrud.tileHeight,
          width: BaseCrud.dividerWidth / 2,
        ),
      ],
    );
  }

  Widget columnTitles() {
    assert(columns.isNotEmpty);
    if (columns.length == 1) {
      return buildColumnTitle(columns.first);
    }
    List<Widget> titles = [];
    titles.addAll(columns.map(buildColumnTitle));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: titles,
    );
  }

  Widget columnRow(T item) {
    return InkWell(
      onTap: () => widget.onTap != null ? widget.onTap!(item) : update(item),
      hoverColor: widget.itemHoverColor,
      child: SizedBox(
        height: BaseCrud.tileHeight,
        child: columnItems(item),
      ),
    );
  }

  Widget columnItems(T item) {
    assert(columns.isNotEmpty);
    if (columns.length == 1) {
      return buildColumnElem(columns.first, item);
    }
    List<Widget> titles = [];
    titles.add(buildColumnElem(columns.first, item));
    titles.addAll(columns
        .sublist(1, columns.length - 1)
        .map((col) => buildColumnElem(col, item)));
    titles.add(buildColumnElem(columns.last, item));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: titles,
    );
  }

  Widget buildColumnTitle(ColumnData columnData) {
    return Flexible(
        flex: columnData.flex,
        child: columnTitleWrapper(context,
            child: Center(
              child: Text(
                columnData.name,
                style: columnTitleStyle(context),
              ),
            )));
  }

  Widget buildColumnElem(ColumnData<T> columnData, T item) {
    return Flexible(
        flex: columnData.flex,
        child: columnWrapper(
          context,
          child: columnData.buildColumnElem(item),
        ));
  }

  void create() async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ServiceIO().showWidget(context, showDoneButton: false,
          child: widget.formBuilder(onSubmit: (value) async {
        int? id = await widget.crudApi.create(value);
        if (id == null) {
          await Future.microtask(() {
            ServiceIO().showMessage("Could not create the entity :/", context);
          });
        } else {
          setState(() {
            value.setId(id);
            widget.items.add(value);
          });
        }
      }));
    });
  }

  void update(T value) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ServiceIO().showWidget(context, showDoneButton: false,
          child: widget.formBuilder(
            onSubmit: (updatedTourist) async {
              bool? updated = await widget.crudApi.update(updatedTourist);
              if (!updated) {
                await Future.microtask(() {
                  ServiceIO()
                      .showMessage("Could not update the entity :/", context);
                });
              } else {
                setState(() {
                  int idx = widget.items.indexOf(value);
                  widget.items.removeAt(idx);
                  widget.items.insert(idx, updatedTourist);
                });
              }
            },
            initial: value,
          ));
    });
  }

  void delete(T value) async {
    ServiceIO().showProgressCircle(context);
    bool deleted = await widget.crudApi.delete(value);
    await Future.microtask(() {
      Navigator.of(context).pop();
    });
    if (!deleted) {
      await Future.microtask(() {
        ServiceIO().showMessage(
            "Could not delete entity with ID ${value.getId()}", context);
      });
      return;
    }
    setState(() {
      widget.items.remove(value);
    });
  }
}
