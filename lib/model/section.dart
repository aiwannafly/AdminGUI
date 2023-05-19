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
  int id;
  final String name;
  final SectionManager sectionManager;

  Section({required this.id, required this.name, required this.sectionManager});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}