import 'package:tourist_admin_panel/model/base_entity.dart';

class PlaceBuilder {
  late int id;
  late String name;
  late String address;
  late double latitude;
  late double longitude;

  PlaceBuilder();

  PlaceBuilder.fromExisting(Place p) {
    id = p.id;
    name = p.name;
    address = p.address;
    latitude = p.latitude;
    longitude = p.longitude;
  }

  Place build() {
    return Place(
        name: name,
        address: address,
        latitude: latitude,
        longitude: longitude,
        id: id);
  }
}

class Place extends BaseEntity {
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Place(
      {required this.name,
      required this.address,
      required this.latitude,
      required this.longitude,
      required super.id});
}
