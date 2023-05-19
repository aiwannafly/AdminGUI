import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/trainer_api.dart';
import 'package:tourist_admin_panel/api/section_api.dart';

import '../model/group.dart';

class GroupApi extends CRUDApi<Group> {
  static final _crudApi = BaseCRUDApi<Group>(
      singleApiName: "group",
      multiApiName: "groups",
      toJSON: toJSON,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Group g) {
    return {
      "id": g.id,
      "name": g.name,
      "trainer": TrainerApi.toMap(g.trainer),
      "section": SectionApi.toMap(g.section)
    };
  }

  static String toJSON(Group g) {
    return jsonEncode(toMap(g));
  }

  static Group fromJSON(dynamic json) {
    return Group(
        id: json["id"],
        name: json["name"],
        trainer: TrainerApi.fromJSON(json["trainer"]),
        section: SectionApi.fromJSON(json["section"]));
  }

  @override
  Future<int?> create(Group value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(Group value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<Group>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Group value) {
    return _crudApi.update(value);
  }
}
