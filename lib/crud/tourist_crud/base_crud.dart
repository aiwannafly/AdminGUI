import 'package:flutter/material.dart';

import '../../config/config.dart';
import '../../responsive.dart';

class ColumnData<T> {
  final String name;
  final Widget Function(T) buildColumnElem;
  final int flex;

  ColumnData(
      {required this.name, required this.buildColumnElem, required this.flex});
}

class BaseCrud<T> extends StatefulWidget {
  static const double dividerWidth = .25;
  static const tileHeight = 40.0;

  const BaseCrud(
      {super.key,
      required this.title,
      required this.items,
      required this.columns,
      required this.onTap,
      required this.onUpdate,
      required this.onDelete,
      required this.onCreate,
      required this.filters,
      required this.tailFlex,
      this.buildUnderneath});

  final void Function(T) onTap;
  final String title;
  final Future Function() onCreate;
  final Future Function(T) onUpdate;
  final Future Function(T) onDelete;
  final Widget Function(T)? buildUnderneath;
  final List<T> items;
  final List<ColumnData<T>> columns;
  final Widget filters;
  final int tailFlex;

  @override
  State<BaseCrud<T>> createState() => _BaseCrudState<T>();
}

class _BaseCrudState<T> extends State<BaseCrud<T>> {
  Color get dividerColor => Colors.grey.shade600;
  late final List<ColumnData<T>> columns = widget.columns;

  @override
  void initState() {
    super.initState();
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
        onTap: () => widget.onUpdate(item),
      ),
      PopupMenuItem(
        value: 2,
        child: Text(
          "Delete",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        onTap: () => widget.onDelete(item),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Column(
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
                        ElevatedButton.icon(
                          style: TextButton.styleFrom(
                            padding: Config.paddingAll,
                          ),
                          onPressed: widget.onCreate,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: Padding(
                            padding: Config.paddingAll,
                            child: Text(
                              "Add New",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
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
                    height: Config.pageHeight(context) * .7,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                          right: Config.defaultPadding * 2),
                      itemBuilder: (BuildContext context, int index) =>
                          columnRow(widget.items[index]),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        color: Colors.grey.shade600,
                        thickness: BaseCrud.dividerWidth,
                        height: 1,
                      ),
                      itemCount: widget.items.length,
                    ),
                  ),
                ],
              ),
            ),
            Responsive(mobile: const SizedBox(), desktop: widget.filters),
          ],
        ),
      ),
    );
  }

  Widget columnTitleWrapper(BuildContext context,
      {required Widget child, Position position = Position.center}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: position == Position.left
              ? const BorderRadius.horizontal(
                  left: Radius.circular(Config.defaultRadius))
              : position == Position.right
                  ? const BorderRadius.horizontal(
                      right: Radius.circular(Config.defaultRadius))
                  : null,
          border:
              Border.all(color: dividerColor, width: BaseCrud.dividerWidth)),
      padding: Config.paddingAll,
      child: child,
    );
  }

  TextStyle? columnTitleStyle(BuildContext context) {
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
    titles.add(buildColumnTitle(columns.first, Position.left));
    titles.addAll(columns
        .sublist(1, columns.length - 1)
        .map(buildColumnTitle));
    titles.add(buildColumnTitle(columns.last, Position.right));
    return Row(
      children: titles,
    );
  }

  Widget columnRow(T item) {
    return InkWell(
      onTap: () => widget.onTap(item),
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
      children: titles,
    );
  }

  Widget buildColumnTitle(ColumnData columnData,
      [Position position = Position.center]) {
    return Expanded(
        flex: columnData.flex,
        child: columnTitleWrapper(context,
            child: Center(
              child: Text(
                columnData.name,
                style: columnTitleStyle(context),
              ),
            ),
            position: position));
  }

  Widget buildColumnElem(ColumnData<T> columnData, T item,
      [Position position = Position.center]) {
    return Expanded(
        flex: columnData.flex,
        child: columnWrapper(
          context,
          child: columnData.buildColumnElem(item),
        ));
  }
}
