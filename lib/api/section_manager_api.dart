import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

class SectionManagerApi extends CRUDApi<SectionManager> {
  SectionManagerApi._internal();

  static final _crudApi = BaseCRUDApi<SectionManager>(
      singleApiName: "sectionManager",
      multiApiName: "sectionManagers",
      toJSON: toJSON,
      fromJSON: fromJSON);

  factory SectionManagerApi() {
    return SectionManagerApi._internal();
  }

  @override
  Future<List<SectionManager>?> getAll() async {
    return _crudApi.getAll();
  }

  @override
  Future<int?> create(SectionManager s) async {
    return _crudApi.create(s);
  }

  @override
  Future<bool> update(SectionManager s) async {
    return _crudApi.update(s);
  }

  @override
  Future<bool> delete(SectionManager s) async {
    return _crudApi.delete(s);
  }

  static String toJSON(SectionManager s) {
    return jsonEncode(toMap(s));
  }

  static Map<String, dynamic> toMap(SectionManager s) {
    return {
      "id": s.id,
      "salary": s.salary,
      "secondName": s.secondName,
      "firstName": s.firstName,
      "employmentYear": s.employmentYear,
      "birthYear": s.birthYear
    };
  }

  static SectionManager fromJSON(dynamic json) {
    var builder = SectionManagerBuilder()
      ..id = json["id"]
      ..salary = json["salary"]
      ..secondName = json["secondName"]
      ..firstName = json["firstName"]
      ..employmentYear = json["employmentYear"]
      ..birthYear = json["birthYear"];
    return builder.build();
  }
}
