abstract class CRUDApi<T> {
  Future<int?> create(T value, [List<String>? errors]);

  Future<bool> update(T value, [List<String>? errors]);

  Future<bool> delete(T value, [List<String>? errors]);

  Future<List<T>?> getAll();
}
