import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

class SectionBuilder {
  late int id;
  late String name;
  late SectionManager sectionManager;

  SectionBuilder();

  SectionBuilder.fromExisting(Section s) {
    id = s.id;
    name = s.name;
    sectionManager = s.sectionManager;
  }

  Section build() {
    return Section(id: id, name: name, sectionManager: sectionManager);
  }
}

class Section extends BaseEntity {
  final String name;
  final SectionManager sectionManager;

  Section({required super.id, required this.name, required this.sectionManager});
}