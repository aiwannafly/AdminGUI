abstract class BaseEntity {
  int id;

  BaseEntity({required this.id});

  int getId() {
    return id;
  }

  void setId(int id) {
    this.id = id;
  }

  @override
  bool operator==(Object o) {
    if (o.runtimeType != runtimeType){
      return false;
    }
    return hashCode == o.hashCode;
  }

  @override
  int get hashCode => getId();
}
