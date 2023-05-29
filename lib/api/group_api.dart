import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';

import '../model/group.dart';

class GroupApi extends CRUDApi<Group> {
  static final _crudApi = BaseCRUDApi<Group>(
      singleApiName: "group",
      multiApiName: "groups",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Group g) {
    return {
      "id": g.id,
      "name": g.name,
      "trainer": TrainerApi.toMap(g.trainer)
    };
  }

  static Group fromJSON(dynamic json) {
    return Group(
        id: json["id"],
        name: json["name"],
        trainer: TrainerApi.fromJSON(json["trainer"]));
  }

  @override
  Future<int?> create(Group value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(Group value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<Group>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Group value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
