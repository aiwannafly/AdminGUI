import 'package:tourist_admin_panel/model/base_entity.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

class SportsmanBuilder {
  late int id;
  late Tourist tourist;

  SportsmanBuilder();

  SportsmanBuilder.fromExisting(Sportsman t) {
    id = t.id;
    tourist = t.tourist;
  }

  Sportsman build() {
    return Sportsman(id: id, tourist: tourist);
  }
}

class Sportsman extends BaseEntity {
  final Tourist tourist;

  Sportsman(
      {required super.id,
        required this.tourist});

}
