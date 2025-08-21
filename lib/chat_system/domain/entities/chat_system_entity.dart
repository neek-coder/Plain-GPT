import 'dart:collection' show UnmodifiableListView;

import 'chat_system_object_entity.dart';

export 'chat_system_object_entity.dart';
export '../repositories/chat_system_object_id_repository_interface.dart';

final class ChatSystemEntity {
  final _root = ChatFolderEntity(id: -1, name: 'root');

  ChatSystemEntity({required Set<ChatSystemObjectEntity> content}) {
    _root.addAll(content);
  }

  UnmodifiableListView<ChatSystemObjectEntity> get content => _root.children;

  bool add(ChatSystemObjectEntity object, [ChatFolderEntity? to]) {
    if (to != null) {
      return to.add(object);
    }

    return _root.add(object);
  }

  bool remove(ChatSystemObjectEntity object,
      [ChatFolderEntity? from, void Function(ChatEntity chat)? onChatRemoved]) {
    if (from != null) {
      return from.remove(object, onChatRemoved);
    }

    return _root.remove(object, onChatRemoved);
  }

  bool move({
    required ChatSystemObjectEntity object,
    ChatFolderEntity? from,
    ChatFolderEntity? to,
  }) {
    from ??= _root;
    to ??= _root;

    // Handles both cases when id are equal or from and to are null
    if (from.id == to.id) return false;

    // Prevent mpving folder into itseld
    if (object.id == to.id) return false;

    // Prevent a folder from moving into it's child
    if (object is ChatFolderEntity) {
      var f = to;

      while (f.parentFolder != null) {
        if (f.parentFolder!.id == object.id) {
          return false;
        }

        f = f.parentFolder!;
      }
    }

    if (!from.contains(object)) {
      return false;
    }

    if (!to.add(object)) {
      return false;
    }

    from.remove(object);

    return true;
  }

  bool insertAbove({
    required ChatSystemObjectEntity object,
    required ChatSystemObjectEntity anchor,
  }) {
    // Preventing folder from moving into itself
    if (object is ChatFolderEntity) {
      if (_isNestedInto(object, anchor)) return false;
    }

    if (object.parentFolder == null || anchor.parentFolder == null) {
      return false;
    }

    final anchorIndex = anchor.parentFolder!.indexOf(anchor)!;

    // If objects share the same directory
    if (object.parentFolder == anchor.parentFolder) {
      return object.parentFolder!.moveTo(object, anchorIndex);
    }

    object.parentFolder!.remove(object);
    anchor.parentFolder!.insert(object, anchorIndex);

    return true;
  }

  bool insertBelow({
    required ChatSystemObjectEntity object,
    required ChatSystemObjectEntity anchor,
  }) {
    // Preventing folder from moving into itself
    if (object is ChatFolderEntity) {
      if (_isNestedInto(object, anchor)) return false;
    }

    if (object.parentFolder == null || anchor.parentFolder == null) {
      return false;
    }

    final anchorIndex = anchor.parentFolder!.indexOf(anchor)!;

    // If objects share the same directory
    if (object.parentFolder == anchor.parentFolder) {
      return object.parentFolder!.moveTo(object, anchorIndex + 1);
    }

    object.parentFolder!.remove(object);
    anchor.parentFolder!.insert(object, anchorIndex + 1);

    return true;
  }

  bool _isNestedInto(ChatFolderEntity folder, ChatSystemObjectEntity object) {
    var nextFolder = object.parentFolder;

    while (nextFolder != null && folder != nextFolder) {
      nextFolder = nextFolder.parentFolder;
    }

    return nextFolder != null;
  }
}
