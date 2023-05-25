import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/model/base_entity.dart';
import 'api_fields.dart';

class BaseCRUDApi<T extends BaseEntity> extends CRUDApi<T> {
  final String singleApiName;
  final String multiApiName;
  final Map<String, dynamic> Function(T) toMap;
  final T Function(dynamic) fromJSON;

  BaseCRUDApi(
      {required this.singleApiName,
      required this.multiApiName,
      required this.toMap,
      required this.fromJSON});

  @override
  Future<int?> create(T value) async {
    var response = await http.post(Uri.parse('$apiUri$singleApiName'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(toMap(value)));
    if (response.statusCode != 200) {
      return null;
    }
    return jsonDecode(response.body)["id"];
  }

  @override
  Future<List<T>?> getAll() async {
    return getAllByUrl(multiApiName);
  }

  Future<List<T>?> getAllByUrl(String url) async {
    var response = await http.get(Uri.parse("$apiUri$url"));
    if (response.statusCode != 200) {
      return null;
    }
    var decodedBody = utf8.decode(response.body.codeUnits);
    var collectionJson = jsonDecode(decodedBody);
    List<T> values = [];
    for (dynamic json in collectionJson) {
      values.add(fromJSON(json));
    }
    return values;
  }

  @override
  Future<bool> update(T value) async {
    var response =
        await http.post(Uri.parse('$apiUri$singleApiName/${value.getId()}'),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: jsonEncode(toMap(value)));
    return response.statusCode == 200;
  }

  @override
  Future<bool> delete(T value) async {
    var response =
        await http.delete(Uri.parse('$apiUri$singleApiName/${value.getId()}'));
    return response.statusCode == 200;
  }
}
