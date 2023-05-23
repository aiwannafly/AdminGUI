import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/section_manager_api.dart';

import '../model/section.dart';

class SectionApi extends CRUDApi<Section> {
  static final _crudApi = BaseCRUDApi<Section>(
      singleApiName: "section",
      multiApiName: "sections",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Section s) {
    return {
      "id": s.id,
      "name": s.name,
      "sectionManager": SectionManagerApi.toMap(s.sectionManager)
    };
  }

  static Section fromJSON(dynamic json) {
    var builder = SectionBuilder()
      ..id = json["id"]
      ..name = json["name"]
      ..sectionManager = SectionManagerApi.fromJSON(json["sectionManager"]);
    return builder.build();
  }

  @override
  Future<int?> create(Section value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(Section value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<Section>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Section value) {
    return _crudApi.update(value);
  }
}
