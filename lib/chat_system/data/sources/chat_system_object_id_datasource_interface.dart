abstract class ChatSystemObjectIdDatasourceIntf {
  Future<void> init();
  int? getLastId();
  Future<void> saveLastId(int id);
}
