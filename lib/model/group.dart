import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/section.dart';
import 'package:tourist_admin_panel/model/trainer.dart';

class GroupBuilder {
  late int id;
  late String name;
  late Trainer trainer;
  late Section section;

  GroupBuilder();

  GroupBuilder.fromExisting(Group g) {
    id = g.id;
    name = g.name;
    trainer = g.trainer;
    section = g.section;
  }

  Group build() {
    return Group(id: id, name: name, trainer: trainer, section: section);
  }
}

class Group extends BaseEntity {
  int id;
  final String name;
  final Trainer trainer;
  final Section section;

  Group(
      {required this.id,
      required this.name,
      required this.trainer,
      required this.section});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}
