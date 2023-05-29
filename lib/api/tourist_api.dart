import 'dart:convert';

import 'package:tourist_admin_panel/model/route.dart';

import 'api_fields.dart';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/group_api.dart';
import 'package:tourist_admin_panel/crud/filters/tourist_filters.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class TouristApi extends CRUDApi<Tourist> {
  TouristApi._internal();

  static final _crudApi = BaseCRUDApi<Tourist>(
      singleApiName: "tourist",
      multiApiName: "tourists",
      toMap: toMap,
      fromJSON: fromJSON);

  factory TouristApi() {
    return TouristApi._internal();
  }

  @override
  Future<List<Tourist>?> getAll() async {
    return _crudApi.getAll();
  }

  Future<List<Tourist>?> findTrainerAndSportsmanCandidates() async {
    return _crudApi.getAllByUrl("search/trainers/candidates");
  }

  Future<List<Tourist>?> findByGroup({required int groupId}) async {
    return _crudApi.getAllByUrl('search/tourists/group/$groupId');
  }

  Future<List<Tourist>?> findByRoutes(
      {required int groupId, required List<RouteTrip> routes}) async {
    String ids = routes
        .sublist(1)
        .fold(routes[0].id.toString(), (prev, curr) => "$prev,${curr.id}");
    return _crudApi.getAllByUrl('search/tourists/group/$groupId/routes?routeIds=$ids');
  }

  Future<List<Tourist>?> findWhoHadTripWithTrainer(
      {required int groupId}) async {
    return _crudApi.getAllByUrl('search/tourists/trainer-trip/group/$groupId');
  }

  Future<List<Tourist>?> findByPlace({required int placeId}) async {
    return _crudApi.getAllByUrl('search/tourists/place/$placeId');
  }

  Future<List<Tourist>?> findByGenderAndSkill() async {
    var genders = TouristFilters.selectedGenders;
    var skillCategories = TouristFilters.selectedSkillCategories;
    int minAge = TouristFilters.ageRangeNotifier.value.start.round();
    int maxAge = TouristFilters.ageRangeNotifier.value.end.round();
    if (genders.isEmpty || skillCategories.isEmpty) {
      return [];
    }
    int minBirthYear = DateTime.now().year - maxAge;
    int maxBirthYear = DateTime.now().year - minAge;
    String gendersStr =
        genders.fold("", (prev, curr) => "$prev,${curr.string}").substring(1);
    String skillsStr = skillCategories
        .fold("", (prev, curr) => "$prev,${curr.string}")
        .substring(1);
    return _crudApi.getAllByUrl(
        'search/tourists?genders=$gendersStr&skillCategories=$skillsStr&minBirthYear=$minBirthYear&maxBirthYear=$maxBirthYear');
  }

  @override
  Future<int?> create(Tourist value, [List<String>? errors]) async {
    return _crudApi.create(value, errors);
  }

  static Map<String, dynamic> toMap(Tourist tourist) {
    return {
      "id": tourist.id,
      "birthYear": tourist.birthYear,
      "firstName": tourist.firstName,
      "secondName": tourist.secondName,
      "gender": tourist.gender.string,
      "group": tourist.group == null ? null : GroupApi.toMap(tourist.group!),
      "skillCategory": tourist.skillCategory.string.toUpperCase()
    };
  }

  @override
  Future<bool> update(Tourist value, [List<String>? errors]) async {
    return _crudApi.update(value, errors);
  }

  @override
  Future<bool> delete(Tourist value, [List<String>? errors]) async {
    return _crudApi.delete(value, errors);
  }

  static Tourist fromJSON(dynamic data) {
    TouristBuilder builder = TouristBuilder()
      ..id = data["id"]
      ..birthYear = data["birthYear"]
      ..firstName = data["firstName"]
      ..secondName = data["secondName"]
      ..group = data["group"] == null ? null : GroupApi.fromJSON(data["group"])
      ..gender = GenderExtension.fromString(data["gender"])
      ..skillCategory = SkillCateforyExtension.fromString(data["skillCategory"])
      ..build();
    return builder.build();
  }
}
