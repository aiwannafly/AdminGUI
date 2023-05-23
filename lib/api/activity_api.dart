import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/schedule_api.dart';
import 'package:tourist_admin_panel/api/tourist_api.dart';
import 'package:tourist_admin_panel/model/activity.dart';
import 'package:tourist_admin_panel/model/tourist.dart';
import 'package:tourist_admin_panel/utils.dart';

import 'base_crud_api.dart';

class ActivityApi extends CRUDApi<Activity> {
  static final _crudApi = BaseCRUDApi<Activity>(
      singleApiName: "activity",
      multiApiName: "activities",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Activity a) {
    return {
      "id": a.id,
      "schedule": ScheduleApi.toMap(a.schedule),
      "date": dateTimeToStr(a.date),
      "attended": a.attended.map((e) => TouristApi.toMap(e)).toList()
    };
  }

  static Activity fromJSON(dynamic json) {
    List<Tourist> attended = [];
    for (dynamic tJson in json["attended"]) {
      attended.add(TouristApi.fromJSON(tJson));
    }
    return Activity(
        id: json["id"],
        schedule: ScheduleApi.fromJSON(json["schedule"]),
        date: DateTime.parse(json["date"]),
        attended: attended);
  }

  @override
  Future<int?> create(Activity value) {
    return _crudApi.create(value);
  }

  @override
  Future<bool> delete(Activity value) {
    return _crudApi.delete(value);
  }

  @override
  Future<List<Activity>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Activity value) {
    return _crudApi.update(value);
  }
}
