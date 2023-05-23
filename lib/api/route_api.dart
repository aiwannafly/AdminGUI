import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/place_api.dart';
import 'package:tourist_admin_panel/model/place.dart';

import '../model/route.dart';

class RouteApi extends CRUDApi<RouteTrip> {
  static final _crudApi = BaseCRUDApi(
      singleApiName: "route",
      multiApiName: "routes",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(RouteTrip r) {
    return {
      "id": r.id,
      "routeType": r.routeType.string,
      "name": r.name,
      "lengthKm": r.lengthKm,
      "places": r.places.map((e) => PlaceApi.toMap(e)).toList()
    };
  }

  static RouteTrip fromJSON(dynamic json) {
    List<Place> places = [];
    for (dynamic tJson in json["places"]) {
      places.add(PlaceApi.fromJSON(tJson));
    }
    return RouteTrip(
        id: json["id"],
        name: json["name"],
        lengthKm: json["lengthKm"],
        routeType: RouteTypeExtension.fromString(json["routeType"]),
        places: places);
  }

  @override
  Future<int?> create(RouteTrip value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(RouteTrip value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<RouteTrip>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(RouteTrip value) {
    return _crudApi.update(value);
  }
}
