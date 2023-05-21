import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/schedule.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class ActivityBuilder {
  late int id;
  late DateTime date;
  late Schedule schedule;
  late List<Tourist> attended = [];

  ActivityBuilder();

  ActivityBuilder.fromExisting(Activity a) {
    id = a.id;
    date = a.date;
    schedule = a.schedule;
    attended = a.attended;
  }

  Activity build() {
    return Activity(id: id, date: date, schedule: schedule, attended: attended);
  }
}

class Activity extends BaseEntity {
  int id;
  final DateTime date;
  final Schedule schedule;
  final List<Tourist> attended;

  Activity(
      {required this.id,
      required this.date,
      required this.schedule,
      required this.attended});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}
