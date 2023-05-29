import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/route_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/model/trip.dart';
import 'package:tourist_admin_panel/utils.dart';

class TripApi extends CRUDApi<Trip> {
  static final _crudApi = BaseCRUDApi<Trip>(
      singleApiName: "trip",
      multiApiName: "trips",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Trip t) {
    return {
      "id": t.id,
      "route": RouteApi.toMap(t.route),
      "instructor": TouristApi.toMap(t.instructor),
      "tourists": t.tourists.map((e) => TouristApi.toMap(e)).toList(),
      "startDate": dateTimeToStr(t.startDate),
      "durationDays": t.durationDays,
      "requiredSkillCategory": t.requiredSkillCategory.string.toUpperCase()
    };
  }

  static Trip fromJSON(dynamic json) {
    List<Tourist> tourists = [];
    for (dynamic tJson in json["tourists"]) {
      tourists.add(TouristApi.fromJSON(tJson));
    }
    return Trip(
        id: json["id"],
        route: RouteApi.fromJSON(json["route"]),
        requiredSkillCategory:
            SkillCateforyExtension.fromString(json["requiredSkillCategory"]),
        instructor: TouristApi.fromJSON(json["instructor"]),
        tourists: tourists,
        durationDays: json["durationDays"],
        startDate: DateTime.parse(json["startDate"]));
  }

  @override
  Future<int?> create(Trip value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(Trip value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<Trip>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Trip value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
