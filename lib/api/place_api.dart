import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';

import '../model/place.dart';

class PlaceApi extends CRUDApi<Place> {
  static final _crudApi = BaseCRUDApi<Place>(
      singleApiName: "place",
      multiApiName: "places",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Place p) {
    return {
      "id": p.id,
      "name": p.name,
      "address": p.address,
      "latitude": p.latitude,
      "longitude": p.longitude
    };
  }

  static Place fromJSON(dynamic json) {
    return Place(
        name: json["name"],
        address: json["address"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        id: json["id"]);
  }

  @override
  Future<int?> create(Place value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(Place value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<Place>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Place value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
