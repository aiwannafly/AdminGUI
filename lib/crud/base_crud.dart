import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/components/hover_wrapper.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
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
      this.titleNotifier,
      required this.filters,
      required this.tailFlex,
      required this.crudApi,
      required this.formBuilder,
      this.modifiable = true,
      this.itemHoverColor});

  final ValueNotifier<String>? titleNotifier;
  final void Function(T)? onTap;
  final String title;
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
  late ValueNotifier<String> titleNotifier;
  int? activeElemId;

  @override
  void initState() {
    super.initState();
    if (widget.titleNotifier != null) {
      titleNotifier = widget.titleNotifier!;
    } else {
      titleNotifier = ValueNotifier(widget.title);
    }
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
        children: [
          Flexible(
            flex: 5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Responsive(desktop: const SizedBox(), mobile: widget.filters),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Config.defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: titleNotifier,
                        builder: (context, title, child) => Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Visibility(
                          visible: widget.modifiable,
                          child: SimpleButton(
                            onPressed: create,
                            color: Config.secondaryColor,
                            text: "Add new",
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: Config.defaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Config.defaultPadding),
                  child: columnTitles(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Config.defaultPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.items.map((e) => columnRow(e)).toList(),
                  ),
                ),
                Visibility(
                    visible: widget.items.isEmpty,
                    child: Container(
                        padding: Config.paddingAll,
                        child: Config.defaultText("No entities were found")))
              ],
            ),
          ),
          Responsive(
              mobile: const SizedBox(),
              desktop: Container(
                width: 2,
                height: Config.pageHeight(context) * .8,
                color: Config.secondaryColor,
              )),
          const Responsive(
              mobile: SizedBox(),
              desktop: SizedBox(
                width: Config.defaultPadding * 2,
              )),
          Responsive(mobile: const SizedBox(), desktop: widget.filters),
        ],
      ),
    );
  }

  Widget columnTitleWrapper(BuildContext context, {required Widget child}) {
    return Container(
      color: Config.secondaryColorDarken, // Colors.indigo.withOpacity(.3),
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
        Expanded(child: Center(child: child)),
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
    bool shine = false;
    if (activeElemId != null) {
      if (widget.items.indexOf(item) == activeElemId) {
        shine = true;
        activeElemId = null;
      }
    }
    return HoverWrapper(
        key: shine ? Key(Random().nextInt(100000).toString()) : null,
        shadowColor: Config.secondaryColor,
        shineWhenAppear: shine,
        onTap: () => widget.onTap != null ? widget.onTap!(item) : update(item),
        child: SizedBox(
          height: BaseCrud.tileHeight,
          child: columnItems(item),
        ));
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
        List<String> errors = [];
        int? id;
        Future.microtask(() => ServiceIO().showProgressCircle(context))
            .then((_) async {
          id = await widget.crudApi.create(value, errors);
        }).then((_) {
          Navigator.of(context).pop();
          if (id == null) {
            Future.microtask(() {
              if (errors.isEmpty) {
                ServiceIO()
                    .showMessage("Could not create the entity :/", context);
              } else {
                ServiceIO().showMessage(errors.first, context);
              }
            });
          } else {
            Future.microtask(() {
              Navigator.of(context).pop();
            }).then((_) => setState(() {
              value.setId(id!);
              widget.items.add(value);
              activeElemId = widget.items.length - 1;
            }));
          }
        });
      }));
    });
  }

  void update(T value) async {
    await Future.delayed(const Duration(milliseconds: 10), () {
      ServiceIO().showWidget(context,
          showDoneButton: false,
          child: widget.formBuilder(
            onSubmit: (newVal) async {
              List<String> errors = [];
              bool updated = false;
              Future.microtask(() => ServiceIO().showProgressCircle(context))
                  .then((_) async {
                updated = await widget.crudApi.update(newVal, errors);
              }).then((_) {
                Navigator.of(context).pop();
                if (!updated) {
                  Future.microtask(() {
                    if (errors.isEmpty) {
                      ServiceIO().showMessage(
                          "Could not update the entity :/", context);
                    } else {
                      ServiceIO().showMessage(errors.first, context);
                    }
                  });
                } else {
                  Future.microtask(() {
                    Navigator.of(context).pop();
                  }).then((_) => setState(() {
                    int idx = widget.items.indexOf(value);
                    widget.items.removeAt(idx);
                    widget.items.insert(idx, newVal);
                    activeElemId = idx;
                  }));
                }
              });
            },
            initial: value,
          ));
    });
  }

  void delete(T value) async {
    ServiceIO().showProgressCircle(context);
    List<String> errors = [];
    bool deleted = await widget.crudApi.delete(value, errors);
    await Future.microtask(() {
      Navigator.of(context).pop();
    });
    if (!deleted) {
      String postfix = "";
      if (errors.isNotEmpty) {
        postfix = " : ${errors.first}";
      }
      await Future.microtask(() {
        ServiceIO().showMessage(
            "Could not delete entity with ID ${value.getId()}$postfix",
            context);
      });
      return;
    }
    await Future.microtask(() {
      Navigator.of(context).pop();
    });
    setState(() {
      widget.items.remove(value);
    });
  }
}
