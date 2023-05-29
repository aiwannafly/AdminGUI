import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/api/instructor_api.dart';
import 'package:tourist_admin_panel/crud/place_crud.dart';
import 'package:tourist_admin_panel/crud/route_crud.dart';
import 'package:tourist_admin_panel/crud/schedule_crud.dart';
import 'package:tourist_admin_panel/crud/section_crud.dart';
import 'package:tourist_admin_panel/crud/section_manager_crud.dart';
import 'package:tourist_admin_panel/crud/select_lists/route_select_list.dart';
import 'package:tourist_admin_panel/crud/tourist_crud.dart';
import 'package:tourist_admin_panel/crud/trainer_crud.dart';
import 'package:tourist_admin_panel/crud/trip_crud.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/group.dart';
import 'package:tourist_admin_panel/model/place.dart';
import 'package:tourist_admin_panel/model/route.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/model/trip.dart';

import '../api/group_api.dart';
import '../api/place_api.dart';
import '../api/route_api.dart';
import '../api/schedule_api.dart';
import '../api/section_api.dart';
import '../api/section_manager_api.dart';
import '../api/tourist_api.dart';
import '../api/trainer_api.dart';
import '../api/trip_api.dart';
import '../config/config.dart';
import '../model/schedule.dart';
import '../model/section.dart';
import '../model/tourist.dart';
import '../model/trainer.dart';
import '../services/service_io.dart';
import 'base_crud_future_builder.dart';
import 'select_lists/place_select_list.dart';
import 'select_lists/tourist_select_list.dart';
import 'group_crud.dart';

class Selector {
  static double width(BuildContext context) =>
      max(900, Config.pageWidth(context) * .5);

  static double height(BuildContext context) =>
      max(300, Config.pageHeight(context) * .5);

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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: ItemsFutureBuilder<Schedule>(
                itemsGetter: ScheduleApi().getAll(),
                contentBuilder: (items) => ScheduleCRUD(
                  items: items,
                  onTap: onSelected,
                  filtersFlex: 0,
                  itemHoverColor: Colors.grey,
                ),
              ),
            )));
  }

  static void selectTourists(BuildContext context,
      {required Set<Tourist> selected,
      VoidCallback? onDispose,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                hideFilters: true,
                onDispose: onDispose,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }

  static void selectTouristsFromGroup(BuildContext context,
      {required Set<Tourist> selected, required Group group,
        VoidCallback? onDispose,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGroup(groupId: group.id),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                hideFilters: true,
                onDispose: onDispose,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }

  static void selectTouristsFromTrainersAndSportsmen(BuildContext context,
      {required Set<Tourist> selected,
        VoidCallback? onDispose,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: InstructorApi().findAllCandidates(),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                hideFilters: true,
                onDispose: onDispose,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }

  static void selectPlaces(BuildContext context,
      {required Set<Place> selected,
      VoidCallback? onDispose,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.topCenter,
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

  static void selectRoutes(BuildContext context,
      {required Set<RouteTrip> selected,
      VoidCallback? onDispose,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
          width: width(context),
          height: height(context),
          color: bgColor,
          padding: Config.paddingAll,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<RouteTrip>(
              itemsGetter: RouteApi().getAll(),
              contentBuilder: (items) => RouteSelectList(
                items: items,
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Section>(
              itemsGetter: SectionApi().getAll(),
              contentBuilder: (sections) => SectionCRUD(
                sections: sections,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Trainer>(
              itemsGetter: TrainerApi().getAll(),
              contentBuilder: (trainers) => TrainerCRUD(
                trainers: trainers,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
  }

  static void selectTrainerBySection(BuildContext context,
      {required void Function(Trainer) onSelected,
      required Section section,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Trainer>(
              itemsGetter: TrainerApi().findBySectionId(section.id),
              contentBuilder: (trainers) => TrainerCRUD(
                trainers: trainers,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
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
          alignment: Alignment.topCenter,
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: ItemsFutureBuilder<Group>(
                itemsGetter: GroupApi().getAll(),
                contentBuilder: (items) => GroupCRUD(
                  items: items,
                  onTap: onSelected,
                  filtersFlex: 0,
                  itemHoverColor: Colors.grey,
                ),
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Place>(
              itemsGetter: PlaceApi().getAll(),
              contentBuilder: (items) => PlaceCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<RouteTrip>(
              itemsGetter: RouteApi().getAll(),
              contentBuilder: (items) => RouteCRUD(
                items: items,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
  }

  static void selectTrip(BuildContext context,
      {required void Function(Trip) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Trip>(
                  itemsGetter: TripApi().getAll(),
                  contentBuilder: (items) => TripCRUD(
                    items: items,
                    onTap: onSelected,
                    filtersFlex: 0,
                    itemHoverColor: Colors.grey,
                  ),
                ))));
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
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristCRUD(
                tourists: tourists,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
  }

  static void selectTrainerAndSportsmanCandidates(BuildContext context,
      {required void Function(Tourist) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Tourist>(
                  itemsGetter: TouristApi().findTrainerAndSportsmanCandidates(),
                  contentBuilder: (tourists) => TouristCRUD(
                    tourists: tourists,
                    onTap: onSelected,
                    filtersFlex: 0,
                    itemHoverColor: Colors.grey,
                  ),
                ))));
  }

  static void selectDate(BuildContext context,
      {required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate,
      required void Function(DateTime) onSelected}) async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (newTime != null) {
      onSelected(newTime);
    }
  }

  static void selectTouristFromTrainersAndSportsmen(BuildContext context,
      {required void Function(Tourist) onSelected,
        Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Tourist>(
                  itemsGetter: InstructorApi().findAllCandidates(),
                  contentBuilder: (tourists) => TouristCRUD(
                    tourists: tourists,
                    onTap: onSelected,
                    filtersFlex: 0,
                    itemHoverColor: Colors.grey,
                  ),
                ))));
  }

  static void selectInstructor(BuildContext context,
      {required void Function(Tourist) onSelected,
      Color barrierColor = Colors.transparent}) {
    ServiceIO().showWidget(context,
        barrierColor: barrierColor,
        child: Container(
            width: width(context),
            height: height(context),
            color: bgColor,
            padding: Config.paddingAll,
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
                child: ItemsFutureBuilder<Tourist>(
              itemsGetter: InstructorApi().findAllCandidates(),
              contentBuilder: (tourists) => TouristCRUD(
                tourists: tourists,
                onTap: onSelected,
                filtersFlex: 0,
                itemHoverColor: Colors.grey,
              ),
            ))));
  }
}
