import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/model/tourist.dart';

import 'api_fields.dart';

class TouristApi {
  TouristApi._internal();

  factory TouristApi() {
    return TouristApi._internal();
  }

  Future<List<Tourist>?> getAll() async {
    var response = await http.get(Uri.parse('${apiUrl}tourists'));
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

  Future<int?> create(Tourist tourist) async {
    var json = _toJSON(tourist);
    var response = await http.post(Uri.parse('${apiUrl}tourist'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json);
    if (response.statusCode != 200) {
      return null;
    }
    return jsonDecode(response.body)["id"];
  }

  String _toJSON(Tourist tourist) {
    Map<String, dynamic> touristDto = {
      "birthYear": tourist.birthYear,
      "firstName": tourist.firstName,
      "secondName": tourist.secondName,
      "gender": tourist.gender.string,
      "skillCategory": tourist.skillCategory.string.toUpperCase()
    };
    return jsonEncode(touristDto);
  }

  Future<bool> update(Tourist tourist) async {
    var json = _toJSON(tourist);
    var response = await http.post(Uri.parse('${apiUrl}tourist/${tourist.id}'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: json);
    return response.statusCode == 200;
  }

  Future<bool> delete(int id) async {
    var response = await http.delete(Uri.parse('${apiUrl}tourist/$id'));
    return response.statusCode == 200;
  }

  Tourist _fromJSON(dynamic data) {
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
