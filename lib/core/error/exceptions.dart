class CacheException implements Exception {
  CacheException();
}

class AddingIntoLocalDBException implements Exception {
  String message;
  AddingIntoLocalDBException(this.message);
}