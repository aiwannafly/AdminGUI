import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/model/sportsman.dart';

class SportsmanApi extends CRUDApi<Sportsman> {
  static final _crudApi = BaseCRUDApi<Sportsman>(
      singleApiName: "sportsman",
      multiApiName: "sportsmen",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Sportsman s) {
    return {"id": s.id, "tourist": TouristApi.toMap(s.tourist)};
  }

  static Sportsman fromJSON(dynamic json) {
    return Sportsman(
        id: json["id"], tourist: TouristApi.fromJSON(json["tourist"]));
  }

  @override
  Future<int?> create(Sportsman value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(Sportsman value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<Sportsman>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Sportsman value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
