import 'package:flutter/cupertino.dart';
import 'package:tourist_admin_panel/api/section_api.dart';
import 'package:tourist_admin_panel/api/section_manager_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/config/config.dart';
import 'package:tourist_admin_panel/crud/base_crud_future_builder.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/crud/section_crud.dart';
import 'package:tourist_admin_panel/crud/tourist_crud.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/model/trainer.dart';
import 'package:tourist_admin_panel/screens/dashboard/components/header.dart';

import '../../api/group_api.dart';
import '../../api/trainer_api.dart';
import '../../crud/group_crud.dart';
import '../../crud/section_manager_crud.dart';
import '../../crud/trainer_crud.dart';
import '../../model/section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

enum CRUD { tourists, groups, sectionManagers, sections, trainers }

class DashboardScreenState extends State<DashboardScreen> {
  var current = CRUD.tourists;
  var touristCrud = BaseCRUDFutureBuilder<Tourist>(
    itemsGetter: TouristApi().findAll(
        TouristFilters.selectedGenders, TouristFilters.selectedSkillCategories),
    contentBuilder: (tourists) => TouristCRUD(
      tourists: tourists,
      onTap: (s) {},
      filtersFlex: 2,
    ),
  );
  var sectionCrud = BaseCRUDFutureBuilder<Section>(
    itemsGetter: SectionApi().getAll(),
    contentBuilder: (sections) => SectionCRUD(
      sections: sections,
      onTap: (s) {},
      filtersFlex: 3,
    ),
  );
  var trainerCrud = BaseCRUDFutureBuilder<Trainer>(
    itemsGetter: TrainerApi().getAll(),
    contentBuilder: (trainers) => TrainerCRUD(
      trainers: trainers,
      onTap: (s) {},
      filtersFlex: 1,
    ),
  );
  var sectionManagerCrud = BaseCRUDFutureBuilder<SectionManager>(
    itemsGetter: SectionManagerApi().getAll(),
    contentBuilder: (sectionManagers) => SectionManagerCRUD(
      sectionManagers: sectionManagers,
      onTap: (s) {},
      filtersFlex: 1,
    ),
  );
  var groupCrud = BaseCRUDFutureBuilder<Group>(
    itemsGetter: GroupApi().getAll(),
    contentBuilder: (items) => GroupCRUD(
      items: items,
      onTap: (s) {},
      filtersFlex: 1,
    ),
  );

  void setContent(CRUD crud) {
    setState(() {
      current = crud;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      primary: true,
      padding: Config.paddingAll * 2,
      child: Column(
        children: [
          const Header(),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          getContent(context)
        ],
      ),
    ));
  }

  Widget getContent(BuildContext context) {
    if (current == CRUD.tourists) {
      return touristCrud;
    } else if (current == CRUD.groups) {
      return groupCrud;
    } else if (current == CRUD.sections) {
      return sectionCrud;
    } else if (current == CRUD.trainers) {
      return trainerCrud;
    }
    return sectionManagerCrud;
  }
}
