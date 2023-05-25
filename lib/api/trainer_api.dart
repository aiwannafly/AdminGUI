import 'dart:convert';

import 'package:tourist_admin_panel/api/api_fields.dart';
import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/section_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/model/tourist.dart';

import '../crud/filters/trainer_filters.dart';
import '../model/trainer.dart';

class TrainerApi extends CRUDApi<Trainer> {
  static final _crudApi = BaseCRUDApi<Trainer>(
      singleApiName: "trainer",
      multiApiName: "trainers",
      toMap: toMap,
      fromJSON: fromJSON);

  static Trainer fromJSON(dynamic json) {
    return Trainer(
        id: json["id"],
        salary: json["salary"],
        section: SectionApi.fromJSON(json["section"]),
        tourist: TouristApi.fromJSON(json["tourist"]));
  }

  static Map<String, dynamic> toMap(Trainer t) {
    return {
      "id": t.id,
      "salary": t.salary,
      "section": SectionApi.toMap(t.section),
      "tourist": TouristApi.toMap(t.tourist)
    };
  }

  Future<List<Trainer>?> findByGenderAndAgeAndSalary() async {
    var genders = TrainerFilters.selectedGenders;
    int minAge = TrainerFilters.ageRangeNotifier.value.start.round();
    int maxAge = TrainerFilters.ageRangeNotifier.value.end.round();
    int minSalary = TrainerFilters.salaryRangeNotifier.value.start.round();
    int maxSalary = TrainerFilters.salaryRangeNotifier.value.end.round();
    if (genders.isEmpty) {
      return [];
    }
    int minBirthYear = DateTime.now().year - maxAge;
    int maxBirthYear = DateTime.now().year - minAge;
    String gendersStr =
        genders.fold("", (prev, curr) => "$prev,${curr.string}").substring(1);
    var response = await http.get(Uri.parse(
        '${apiUri}search/trainers?genders=$gendersStr'
            '&minBirthYear=$minBirthYear&maxBirthYear=$maxBirthYear'
            '&minSalary=$minSalary&maxSalary=$maxSalary'));
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<Trainer> trainers = [];
    for (dynamic entity in collectionJson) {
      trainers.add(fromJSON(entity));
    }
    return trainers;
  }

  @override
  Future<int?> create(Trainer value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(Trainer value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<Trainer>?> getAll() {
    return _crudApi.getAll();
  }

  Future<List<Trainer>?> findBySectionId(int id) async {
    var response =
        await http.get(Uri.parse("${apiUri}search/trainers/section/$id"));
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<Trainer> values = [];
    for (dynamic json in collectionJson) {
      values.add(fromJSON(json));
    }
    return values;
  }

  @override
  Future<bool> update(Trainer value) {
    return _crudApi.update(value);
  }
}
