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

  TouristBuilder();

  TouristBuilder.fromExisting(Tourist tourist) {
    id = tourist.id;
    gender = tourist.gender;
    firstName = tourist.firstName;
    secondName = tourist.secondName;
    birthYear = tourist.birthYear;
    skillCategory = tourist.skillCategory;
  }

  Tourist build() {
    return Tourist(
        id: id,
        gender: gender,
        firstName: firstName,
        secondName: secondName,
        birthYear: birthYear,
        skillCategory: skillCategory);
  }
}

class Tourist {
  int id;
  final Gender gender;
  final String firstName;
  final String secondName;
  final int birthYear;
  final SkillCategory skillCategory;

  Tourist(
      {required this.id,
      required this.gender,
      required this.firstName,
      required this.secondName,
      required this.birthYear,
      required this.skillCategory});
}
