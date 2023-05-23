import 'dart:convert';

import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';
import 'package:http/http.dart' as http;
import '../crud/filters/section_manager_filters.dart';
import 'api_fields.dart';

class SectionManagerApi extends CRUDApi<SectionManager> {
  SectionManagerApi._internal();

  static final _crudApi = BaseCRUDApi<SectionManager>(
      singleApiName: "sectionManager",
      multiApiName: "sectionManagers",
      toMap: toMap,
      fromJSON: fromJSON);

  factory SectionManagerApi() {
    return SectionManagerApi._internal();
  }

  Future<List<SectionManager>?> findByGenderAndAgeAndSalary() async {
    int minAge = SectionManagerFilters.ageRangeNotifier.value.start.round();
    int maxAge = SectionManagerFilters.ageRangeNotifier.value.end.round();
    int minSalary =
        SectionManagerFilters.salaryRangeNotifier.value.start.round();
    int maxSalary = SectionManagerFilters.salaryRangeNotifier.value.end.round();
    int minEmploymentYear =
        SectionManagerFilters.employmentYearNotifier.value.start.round();
    int maxEmploymentYear =
        SectionManagerFilters.employmentYearNotifier.value.end.round();
    int minBirthYear = DateTime.now().year - maxAge;
    int maxBirthYear = DateTime.now().year - minAge;
    var response = await http.get(Uri.parse(
        '${apiUrl}search/sectionManagers?minEmploymentYear=$minEmploymentYear'
        '&maxEmploymentYear=$maxEmploymentYear'
        '&minBirthYear=$minBirthYear&maxBirthYear=$maxBirthYear'
        '&minSalary=$minSalary&maxSalary=$maxSalary'));
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<SectionManager> managers = [];
    for (dynamic entity in collectionJson) {
      managers.add(fromJSON(entity));
    }
    return managers;
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
