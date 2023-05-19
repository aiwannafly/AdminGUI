import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

class SectionManagerApi extends CRUDApi<SectionManager> {
  SectionManagerApi._internal();

  static final _crudApi = BaseCRUDApi<SectionManager>(
      singleApiName: "sectionManager",
      multiApiName: "sectionManagers",
      getId: (s) => s.id,
      toJSON: _toJSON,
      fromJSON: _fromJSON);

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

  static String _toJSON(SectionManager s) {
    Map<String, dynamic> map = {
      "id": s.id,
      "salary": s.salary,
      "secondName": s.secondName,
      "firstName": s.firstName,
      "employmentYear": s.employmentYear,
      "birthYear": s.birthYear
    };
    return jsonEncode(map);
  }

  static SectionManager _fromJSON(dynamic json) {
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
