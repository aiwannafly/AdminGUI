abstract class BaseEntity {
  int getId();

  void setId(int id);

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
