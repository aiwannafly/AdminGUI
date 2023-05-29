import 'package:tourist_admin_panel/api/base_crud_api.dart';
import 'package:tourist_admin_panel/api/crud_api.dart';
import 'package:tourist_admin_panel/api/group_api.dart';
import 'package:tourist_admin_panel/model/schedule.dart';
import 'package:tourist_admin_panel/utils.dart';

class ScheduleApi extends CRUDApi<Schedule> {
  static final _crudApi = BaseCRUDApi<Schedule>(
      singleApiName: "schedule",
      multiApiName: "schedules",
      toMap: toMap,
      fromJSON: fromJSON);

  static Map<String, dynamic> toMap(Schedule s) {
    return {
      "id": s.id,
      "group": GroupApi.toMap(s.group),
      "dayOfWeek": s.dayOfWeek.string,
      "durationMins": s.durationMins,
      "timeOfDay": "${timeOfDayToStr(s.timeOfDay)}:00"
    };
  }

  static Schedule fromJSON(dynamic json) {
    return Schedule(
        id: json["id"],
        durationMins: json["durationMins"],
        group: GroupApi.fromJSON(json["group"]),
        dayOfWeek: DayOfWeekExtension.fromString(json["dayOfWeek"]),
        timeOfDay: timeOfDayFromStr(json["timeOfDay"]));
  }

  @override
  Future<int?> create(Schedule value, [List<String>? errors]) {
    return _crudApi.create(value, errors);
  }

  @override
  Future<bool> delete(Schedule value, [List<String>? errors]) {
    return _crudApi.delete(value, errors);
  }

  @override
  Future<List<Schedule>?> getAll() {
    return _crudApi.getAll();
  }

  @override
  Future<bool> update(Schedule value, [List<String>? errors]) {
    return _crudApi.update(value, errors);
  }
}
