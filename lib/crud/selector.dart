import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/crud/place_crud.dart';
import 'package:tourist_admin_panel/crud/route_crud.dart';
import 'package:tourist_admin_panel/crud/schedule_crud.dart';
import 'package:tourist_admin_panel/crud/section_crud.dart';
import 'package:tourist_admin_panel/crud/section_manager_crud.dart';
import 'package:tourist_admin_panel/crud/tourist_crud.dart';
import 'package:tourist_admin_panel/crud/trainer_crud.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/place.dart';
import 'package:tourist_admin_panel/model/route.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

import '../api/group_api.dart';
import '../api/place_api.dart';
import '../api/route_api.dart';
import '../api/schedule_api.dart';
import '../api/section_api.dart';
import '../api/section_manager_api.dart';
import '../api/tourist_api.dart';
import '../api/trainer_api.dart';
import '../config/config.dart';
import '../model/schedule.dart';
import '../model/section.dart';
import '../model/tourist.dart';
import '../model/trainer.dart';
import '../services/service_io.dart';
import 'base_crud_future_builder.dart';
import 'forms/place_select_list.dart';
import 'forms/tourist_select_list.dart';
import 'group_crud.dart';

class Selector {
  static double width(BuildContext context) =>
      max(900, Config.pageWidth(context) * .5);

  static double height(BuildContext context) =>
      max(400, Config.pageHeight(context) * .5);

  static final bgColor = Config.bgColor.withOpacity(.99);

  static void selectSchedule(BuildContext context,
      {required void Function(Schedule) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Schedule>(
              itemsGetter: ScheduleApi().getAll(),
              contentBuilder: (items) => ScheduleCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectTourists(BuildContext context,
      {required Set<Tourist> selected, VoidCallback? onDispose,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                onDispose: onDispose,
                filtersFlex: 2,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }

  static void selectPlaces(BuildContext context,
      {required Set<Place> selected, VoidCallback? onDispose,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Place>(
              itemsGetter: PlaceApi().getAll(),
              contentBuilder: (items) => PlaceSelectList(
                places: items,
                onDispose: onDispose,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }

  static void selectSection(BuildContext context,
      {required void Function(Section) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Section>(
              itemsGetter: SectionApi().getAll(),
              contentBuilder: (sections) => SectionCRUD(
                sections: sections,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectTrainer(BuildContext context,
      {required void Function(Trainer) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Trainer>(
              itemsGetter: TrainerApi().getAll(),
              contentBuilder: (trainers) => TrainerCRUD(
                trainers: trainers,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectTrainerBySection(BuildContext context,
      {required void Function(Trainer) onSelected, required Section section,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Trainer>(
              itemsGetter: TrainerApi().findBySectionId(section.id),
              contentBuilder: (trainers) => TrainerCRUD(
                trainers: trainers,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectManager(BuildContext context,
      {required void Function(SectionManager) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: ItemsFutureBuilder<SectionManager>(
            itemsGetter: SectionManagerApi().getAll(),
            contentBuilder: (sectionManagers) => SectionManagerCRUD(
              sectionManagers: sectionManagers,
              onTap: onSelected,
              filtersFlex: 0,
              itemHoverColor: Colors.grey,
            ),
          )),
        ));
  }

  static void selectGroup(BuildContext context,
      {required void Function(Group) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Group>(
              itemsGetter: GroupApi().getAll(),
              contentBuilder: (items) => GroupCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectPlace(BuildContext context,
      {required void Function(Place) onSelected,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Place>(
              itemsGetter: PlaceApi().getAll(),
              contentBuilder: (items) => PlaceCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectRoute(BuildContext context,
      {required void Function(RouteTrip) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<RouteTrip>(
              itemsGetter: RouteApi().getAll(),
              contentBuilder: (items) => RouteCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectTourist(BuildContext context,
      {required void Function(Tourist) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristCRUD(
                tourists: tourists,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }

  static void selectInstructor(BuildContext context,
      {required void Function(Tourist) onSelected,
        Color barrierColor = Colors.transparent}) {
    // TODO: use instructor api call
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.center,
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristCRUD(
                tourists: tourists,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            )));
  }
}
