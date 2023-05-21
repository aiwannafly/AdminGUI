import 'package:tourist_admin_panel/model/base_entity.dart';

enum RouteType { pedestrian, mounted, mountain, water }

extension RouteTypeExtension on RouteType {
  static RouteType fromString(String s) {
    s = s.toLowerCase();
    return RouteType.values
        .firstWhere((e) => e.toString() == 'RouteType.$s');
  }

  String get string {
    return toString().substring("RouteType.".length).toUpperCase();
  }
}

class RouteBuilder {
  late int id;
  late String name;
  late RouteType routeType;

  RouteBuilder();

  RouteBuilder.fromExisting(RouteTrip r) {
    id = r.id;
    name = r.name;
    routeType = r.routeType;
  }

  RouteTrip build() {
    return RouteTrip(id: id, name: name, routeType: routeType);
  }
}

class RouteTrip extends BaseEntity {
  int id;
  final String name;
  final RouteType routeType;

  RouteTrip({required this.id, required this.name, required this.routeType});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}
