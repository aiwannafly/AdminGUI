import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/place.dart';

enum RouteType { pedestrian, mounted, mountain, water }

extension RouteTypeExtension on RouteType {
  static RouteType fromString(String s) {
    s = s.toLowerCase();
    return RouteType.values.firstWhere((e) => e.toString() == 'RouteType.$s');
  }

  String get string {
    return toString().substring("RouteType.".length).toUpperCase();
  }
}

class RouteBuilder {
  late int id;
  late String name;
  late RouteType routeType;
  late int lengthKm;
  late List<Place> places;

  RouteBuilder();

  RouteBuilder.fromExisting(RouteTrip r) {
    id = r.id;
    name = r.name;
    routeType = r.routeType;
    lengthKm = r.lengthKm;
    places = r.places;
  }

  RouteTrip build() {
    return RouteTrip(
        id: id,
        name: name,
        routeType: routeType,
        lengthKm: lengthKm,
        places: places);
  }
}

class RouteTrip extends BaseEntity {
  final String name;
  final RouteType routeType;
  final int lengthKm;
  final List<Place> places;

  RouteTrip(
      {required super.id,
      required this.name,
      required this.routeType,
      required this.lengthKm,
      required this.places});
}
