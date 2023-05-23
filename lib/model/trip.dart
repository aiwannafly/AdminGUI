import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/route.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class TripBuilder {
  late int id;
  late RouteTrip route;
  late SkillCategory requiredSkillCategory;
  late Tourist instructor;
  late List<Tourist> tourists;
  late int durationDays;
  late DateTime startDate;

  TripBuilder();

  TripBuilder.fromExisting(Trip t) {
    id = t.id;
    route = t.route;
    requiredSkillCategory = t.requiredSkillCategory;
    instructor = t.instructor;
    tourists = t.tourists;
    durationDays = t.durationDays;
    startDate = t.startDate;
  }

  Trip build() {
    return Trip(id: id,
        route: route,
        requiredSkillCategory: requiredSkillCategory,
        instructor: instructor,
        tourists: tourists,
        durationDays: durationDays,
        startDate: startDate);
  }
}

class Trip extends BaseEntity {
  final RouteTrip route;
  final SkillCategory requiredSkillCategory;
  final Tourist instructor;
  final List<Tourist> tourists;
  final int durationDays;
  final DateTime startDate;

  Trip({required super.id,
    required this.route,
    required this.requiredSkillCategory,
    required this.instructor,
    required this.tourists,
    required this.durationDays,
    required this.startDate});
}
