import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/trainer.dart';

class GroupBuilder {
  late int id;
  late String name;
  late Trainer trainer;

  GroupBuilder();

  GroupBuilder.fromExisting(Group g) {
    id = g.id;
    name = g.name;
    trainer = g.trainer;
  }

  Group build() {
    return Group(id: id, name: name, trainer: trainer);
  }
}

class Group extends BaseEntity {
  final String name;
  final Trainer trainer;

  Group(
      {required super.id,
      required this.name,
      required this.trainer});

}
