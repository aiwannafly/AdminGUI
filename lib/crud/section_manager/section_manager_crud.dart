import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/section_manager_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/crud/connection_error.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/crud/section_manager/section_manager_crud_content.dart';
import 'package:tourist_admin_panel/crud/tourist/tourist_crud_content.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

class SectionManagerCRUD extends StatelessWidget {
  const SectionManagerCRUD({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SectionManagerApi().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<SectionManager>? managers = snapshot.data;
          if (managers == null) {
            return const ConnectionError();
          }
          return SectionManagerCRUDContent(sectionManagers: managers);
          // return TouristCrudContent(tourists: tourists);
        });
  }
}
