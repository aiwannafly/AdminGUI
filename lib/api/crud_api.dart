abstract class CRUDApi<T> {
  Future<int?> create(T value);

  Future<bool> update(T value);

  Future<bool> delete(T value);

  Future<List<T>?> getAll();
}