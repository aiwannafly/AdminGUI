import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/section.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class TrainerBuilder {
  late int id;
  late int salary;
  late Section section;
  late Tourist tourist;

  TrainerBuilder();

  TrainerBuilder.fromExisting(Trainer t) {
    id = t.id;
    salary = t.salary;
    section = t.section;
    tourist = t.tourist;
  }

  Trainer build() {
    return Trainer(id: id, salary: salary, section: section, tourist: tourist);
  }
}

class Trainer extends BaseEntity {
  int id;
  final int salary;
  final Section section;
  final Tourist tourist;

  Trainer(
      {required this.id,
      required this.salary,
      required this.section,
      required this.tourist});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}
