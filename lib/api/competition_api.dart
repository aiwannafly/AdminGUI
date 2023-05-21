import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/model/competition.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/utils.dart';

class CompetitionApi extends CRUDApi<Competition> {
  static final _crudApi = BaseCRUDApi(
      singleApiName: "competition",
      multiApiName: "competitions",
      toJSON: toJSON,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Competition c) {
    return {
      "id": c.id,
      "date": dateTimeToStr(c.date),
      "name": c.name,
      "tourists": c.tourists.map((t) => TouristApi.toMap(t)).toList()
    };
  }

  static String toJSON(Competition c) {
    return jsonEncode(toMap(c));
  }

  static Competition fromJSON(dynamic json) {
    List<Tourist> tourists = [];
    for (var tJson in json["tourists"]) {
      tourists.add(TouristApi.fromJSON(tJson));
    }
    return Competition(
        id: json["id"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        tourists: tourists);
  }

  @override
  Future<int?> create(Competition value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(Competition value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<Competition>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Competition value) {
    return _crudApi.update(value);
  }
}
