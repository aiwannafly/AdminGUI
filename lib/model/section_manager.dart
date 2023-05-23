import 'package:tourist_admin_panel/model/base_entity.dart';

class SectionManagerBuilder {
  late int id;
  late int birthYear;
  late int employmentYear;
  late String firstName;
  late String secondName;
  late int salary;

  SectionManagerBuilder();

  SectionManagerBuilder.fromExisting(SectionManager s) {
    id = s.id;
    birthYear = s.birthYear;
    employmentYear = s.employmentYear;
    firstName = s.firstName;
    secondName = s.secondName;
    salary = s.salary;
  }

  SectionManager build() {
    return SectionManager(
        id: id,
        birthYear: birthYear,
        employmentYear: employmentYear,
        firstName: firstName,
        secondName: secondName,
        salary: salary);
  }
}

class SectionManager extends BaseEntity {
  final int birthYear;
  final int employmentYear;
  final String firstName;
  final String secondName;
  final int salary;

  SectionManager(
      {required super.id,
      required this.birthYear,
      required this.employmentYear,
      required this.firstName,
      required this.secondName,
      required this.salary});

}
