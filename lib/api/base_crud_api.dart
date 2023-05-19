import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'api_fields.dart';

class BaseCRUDApi<T> extends CRUDApi<T> {
  final String singleApiName;
  final String multiApiName;
  final int Function(T) getId;
  final String Function(T) toJSON;
  final T Function(dynamic) fromJSON;

  BaseCRUDApi(
      {required this.singleApiName,
      required this.multiApiName,
      required this.getId,
      required this.toJSON,
      required this.fromJSON});

  @override
  Future<int?> create(T s) async {
    var response = await http.post(Uri.parse('$apiUrl$singleApiName'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: toJSON(s));
    if (response.statusCode != 200) {
      return null;
    }
    return jsonDecode(response.body)["id"];
  }

  @override
  Future<List<T>?> getAll() async {
    var response = await http.get(Uri.parse("$apiUrl$multiApiName"));
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
        await http.post(Uri.parse('$apiUrl$singleApiName/${getId(value)}'),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            },
            body: toJSON(value));
    return response.statusCode == 200;
  }

  @override
  Future<bool> delete(T value) async {
    var response =
        await http.delete(Uri.parse('$apiUrl$singleApiName/${getId(value)}'));
    return response.statusCode == 200;
  }
}
