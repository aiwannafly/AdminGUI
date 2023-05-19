import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/crud/connection_error.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/crud/tourist/tourist_crud_content.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class TouristCRUD extends StatelessWidget {
  const TouristCRUD({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: TouristApi().findAll(TouristFilters.selectedGenders,
            TouristFilters.selectedSkillCategories),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          List<Tourist>? tourists = snapshot.data;
          if (tourists == null) {
            return const ConnectionError();
          }
          return TouristCrudContent(tourists: tourists);
        });
  }
}
