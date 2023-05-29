import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/place_api.dart';
import 'package:tourist_admin_panel/model/place.dart';
import 'package:tourist_admin_panel/model/section.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/utils.dart';

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

  Future<List<RouteTrip>?> findRoutesBySection(Section s) async {
    return _crudApi.getAllByUrl("search/routes/section/${s.id}");
  }

  Future<List<RouteTrip>?> findRoutesByDate(DateTime date) async {
    return _crudApi.getAllByUrl("search/routes/date/${dateTimeToStr(date)}");
  }

  Future<List<RouteTrip>?> findRoutesByInstructor(Tourist t) async {
    return _crudApi.getAllByUrl("search/routes/instructor/${t.id}");
  }

  Future<List<RouteTrip>?> findRoutesByTripsCount(int tripsCount) async {
    return _crudApi.getAllByUrl("search/routes/trips?count=$tripsCount");
  }

  Future<List<RouteTrip>?> findRoutesByPlace(Place t) async {
    return _crudApi.getAllByUrl("search/routes/place/${t.id}");
  }

  Future<List<RouteTrip>?> findRoutesByMinLengthKm(int lengthKm) async {
    return _crudApi.getAllByUrl("search/routes/length?min=$lengthKm");
  }

  @override
  Future<int?> create(RouteTrip value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(RouteTrip value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<RouteTrip>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(RouteTrip value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
