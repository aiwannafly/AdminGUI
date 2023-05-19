import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import 'api_fields.dart';

class TouristApi extends CRUDApi<Tourist> {
  TouristApi._internal();

  static final _crudApi = BaseCRUDApi<Tourist>(
      singleApiName: "tourist",
      multiApiName: "tourists",
      getId: (t) => t.id,
      toJSON: _toJSON,
      fromJSON: _fromJSON);

  factory TouristApi() {
    return TouristApi._internal();
  }

  @override
  Future<List<Tourist>?> getAll() async {
    return _crudApi.getAll();
  }

  Future<List<Tourist>?> findAll(
      Set<Gender> genders, Set<SkillCategory> skillCategories) async {
    if (genders.isEmpty || skillCategories.isEmpty) {
      return [];
    }
    String gendersStr = genders
        .fold(
            "", (previousValue, element) => "$previousValue,${element.string}")
        .substring(1);
    String skillsStr = skillCategories
        .fold(
            "", (previousValue, element) => "$previousValue,${element.string}")
        .substring(1);
    var response = await http.get(Uri.parse(
        '${apiUrl}search/tourists?genders=$gendersStr&skillCategories=$skillsStr'));
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<Tourist> tourists = [];
    for (dynamic entity in collectionJson) {
      tourists.add(_fromJSON(entity));
    }
    return tourists;
  }

  @override
  Future<int?> create(Tourist tourist) async {
    return _crudApi.create(tourist);
  }

  static String _toJSON(Tourist tourist) {
    Map<String, dynamic> touristDto = {
      "birthYear": tourist.birthYear,
      "firstName": tourist.firstName,
      "secondName": tourist.secondName,
      "gender": tourist.gender.string,
      "skillCategory": tourist.skillCategory.string.toUpperCase()
    };
    return jsonEncode(touristDto);
  }

  @override
  Future<bool> update(Tourist tourist) async {
    return _crudApi.update(tourist);
  }

  @override
  Future<bool> delete(Tourist tourist) async {
    return _crudApi.delete(tourist);
  }

  static Tourist _fromJSON(dynamic data) {
    TouristBuilder builder = TouristBuilder()
      ..id = data["id"]
      ..birthYear = data["birthYear"]
      ..firstName = data["firstName"]
      ..secondName = data["secondName"]
      ..gender = GenderExtension.fromString(data["gender"])
      ..skillCategory = SkillCateforyExtension.fromString(data["skillCategory"])
      ..build();
    return builder.build();
  }
}
