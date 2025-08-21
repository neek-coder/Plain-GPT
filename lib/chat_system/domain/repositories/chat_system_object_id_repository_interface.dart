abstract interface class ChatSystemObjectIdRepositoryIntf {
  int get id;
  int generateId();
  Future<void> save();
}
