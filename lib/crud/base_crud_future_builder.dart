import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/connection_error.dart';

class ItemsFutureBuilder<T> extends StatelessWidget {
  const ItemsFutureBuilder(
      {super.key, required this.contentBuilder, required this.itemsGetter});

  final Widget Function(List<T>) contentBuilder;
  final Future<List<T>?> itemsGetter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: itemsGetter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<T>? items = snapshot.data;
          if (items == null) {
            return const ConnectionError();
          }
          return contentBuilder(items);
        });
  }
}
