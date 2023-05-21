import 'package:tourist_admin_panel/model/base_entity.dart';

import 'group.dart';

enum Gender { male, female }

extension GenderExtension on Gender {
  static Gender fromString(String s) {
    if (s == "f") {
      return Gender.female;
    } else if (s == "m") {
      return Gender.male;
    }
    throw "$s is a bad gender";
  }

  String get string {
    return this == Gender.male ? 'm' : 'f';
  }
}

enum SkillCategory { beginner, intermediate, advanced }

extension SkillCateforyExtension on SkillCategory {
  static SkillCategory fromString(String s) {
    s = s.toLowerCase();
    return SkillCategory.values
        .firstWhere((e) => e.toString() == 'SkillCategory.$s');
  }

  String get string {
    return toString().substring("SkillCategory.".length);
  }
}

class TouristBuilder {
  late int id;
  late Gender gender;
  late String firstName;
  late String secondName;
  late int birthYear;
  late SkillCategory skillCategory;
  late Group? group;

  TouristBuilder();

  TouristBuilder.fromExisting(Tourist tourist) {
    id = tourist.id;
    gender = tourist.gender;
    firstName = tourist.firstName;
    secondName = tourist.secondName;
    birthYear = tourist.birthYear;
    skillCategory = tourist.skillCategory;
    group = tourist.group;
  }

  Tourist build() {
    return Tourist(
        id: id,
        gender: gender,
        firstName: firstName,
        secondName: secondName,
        birthYear: birthYear,
        group: group,
        skillCategory: skillCategory);
  }
}

class Tourist extends BaseEntity {
  int id;
  final Gender gender;
  final String firstName;
  final String secondName;
  final int birthYear;
  final SkillCategory skillCategory;
  final Group? group;

  Tourist(
      {required this.id,
      required this.gender,
      required this.firstName,
      required this.secondName,
      required this.birthYear,
      this.group,
      required this.skillCategory});

  @override
  int getId() {
    return id;
  }

  @override
  void setId(int id) {
    this.id = id;
  }
}
