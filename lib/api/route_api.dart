import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';

import '../model/route.dart';

class RouteApi extends CRUDApi<RouteTrip> {
  static final _crudApi = BaseCRUDApi(
      singleApiName: "route",
      multiApiName: "routes",
      toJSON: toJSON,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(RouteTrip r) {
    return {"id": r.id, "routeType": r.routeType.string, "name": r.name};
  }

  static String toJSON(RouteTrip r) {
    return jsonEncode(toMap(r));
  }

  static RouteTrip fromJSON(dynamic json) {
    return RouteTrip(
        id: json["id"],
        name: json["name"],
        routeType: RouteTypeExtension.fromString(json["routeType"]));
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
