import 'package:flutter/material.dart';

import '../config/config.dart';

class SelectorLabel<T> extends StatefulWidget {
  const SelectorLabel(
      {super.key,
      required this.items,
      required this.itemBuilder,
      required this.selectedItems,
      required this.onChange,
      this.selectedColor});

  final List<T> items;
  final Widget Function(T) itemBuilder;
  final Set<T> selectedItems;
  final VoidCallback onChange;
  final Color? selectedColor;

  @override
  State<SelectorLabel<T>> createState() => _SelectorLabelState<T>();
}

class _SelectorLabelState<T> extends State<SelectorLabel<T>> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: Config.defaultPadding,
      runSpacing: Config.defaultPadding,
      children: widget.items.map((e) => buildItemWrapper(context, e)).toList(),
    );
  }

  Color get selectedColor => widget.selectedColor?? Config.secondaryColor.withOpacity(.5);

  Color get defaultColor => Colors.indigo.withOpacity(0.1);

  Widget buildItemWrapper(BuildContext context, T item) {
    return InkWell(
      hoverColor: Colors.grey.shade700,
      borderRadius: Config.borderRadius,
      onTap: () {
        setState(() {
          if (widget.selectedItems.contains(item)) {
            widget.selectedItems.remove(item);
          } else {
            widget.selectedItems.add(item);
          }
          widget.onChange();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            borderRadius: Config.borderRadius,
            color: widget.selectedItems.contains(item)
                ? selectedColor
                : defaultColor),
        padding: Config.paddingAll / 2,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.selectedItems.contains(item)
                ? const Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  )
                : const SizedBox(),
            widget.itemBuilder(item)
          ],
        ),
      ),
    );
  }
}
