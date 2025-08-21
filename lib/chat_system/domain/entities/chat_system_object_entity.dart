import 'dart:collection';

sealed class ChatSystemObjectEntity {
  final int id;
  String name;
  ChatFolderEntity? parentFolder;

  ChatSystemObjectEntity({
    required this.id,
    required this.name,
    this.parentFolder,
  });

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    if (other is ChatSystemObjectEntity) return id == other.id;

    return false;
  }
}

final class ChatFolderEntity extends ChatSystemObjectEntity {
  final List<ChatSystemObjectEntity> _children = [];

  UnmodifiableListView<ChatSystemObjectEntity> get children =>
      UnmodifiableListView(_children);

  ChatFolderEntity({
    required super.id,
    required super.name,
    super.parentFolder,
    Set<ChatSystemObjectEntity>? objects,
  }) {
    if (objects != null) _children.addAll(objects);

    for (final c in _children) {
      c.parentFolder = this;
    }
  }

  /// Adds an [object] to the folder.
  ///
  /// Returns **true** if operation was successfull, that means if [object]
  /// has not been in the folder already.
  bool add(ChatSystemObjectEntity object) {
    if (object.parentFolder != this) {
      object.parentFolder = this;
      _children.add(object);
      return true;
    }

    return false;
  }

  /// Adds all the elements from [objects], that are not already in the folder.
  void addAll(Set<ChatSystemObjectEntity> objects) {
    for (final obj in objects) {
      if (obj.parentFolder != this) {
        obj.parentFolder = this;
        _children.add(obj);
      }
    }
  }

  /// Inserts object at given index.
  ///
  /// Returns **true** if [object] wass added successfully, and **false** otherwise.
  /// This means, the method returns **true** if given [object] is NOT already in this folder,
  /// and provided index is in the range [0, length]
  bool insert(ChatSystemObjectEntity object, int index) {
    if (object.parentFolder != this &&
        index >= 0 &&
        index <= _children.length) {
      object.parentFolder = this;
      _children.insert(index, object);
      return true;
    }

    return false;
  }

  /// Moves an object
  ///
  /// Returns **true** if operation was successfull, that means if [a] is in this folder
  /// and [index] is in the range [0, length].
  bool moveTo(ChatSystemObjectEntity a, int index) {
    if (!(a.parentFolder == this && index >= 0 && index <= _children.length)) {
      return false;
    }

    final i = indexOf(a)!;

    if (i < index) {
      _children.insert(index, a);
      _children.removeAt(i);
    } else if (i > index) {
      _children.removeAt(i);
      _children.insert(index, a);
    }

    return true;
  }

  bool remove(ChatSystemObjectEntity object,
      [void Function(ChatEntity chat)? onChatRemoved]) {
    if (!_children.contains(object)) {
      return false;
    }

    if (object is ChatEntity) {
      _children.remove(object);
      onChatRemoved?.call(object);
    } else if (object is ChatFolderEntity) {
      object._clear(onChatRemoved ?? (_) {});
      _children.remove(object);
    }

    return true;
  }

  void _clear(void Function(ChatEntity chat) onChatRemoved) {
    for (var obj in _children) {
      if (obj is ChatEntity) {
        onChatRemoved(obj);
      } else if (obj is ChatFolderEntity) {
        obj._clear(onChatRemoved);
      }
    }
    _children.clear();
  }

  bool contains(ChatSystemObjectEntity chat) => _children.contains(chat);

  int? indexOf(ChatSystemObjectEntity object) => _children.indexOf(object);
}

final class ChatEntity extends ChatSystemObjectEntity {
  ChatEntity({
    required super.id,
    required super.name,
    super.parentFolder,
  });

  ChatEntity copyWith({
    int? id,
    String? name,
    ChatFolderEntity? parentFolder,
  }) =>
      ChatEntity(
        id: id ?? this.id,
        name: name ?? this.name,
        parentFolder: parentFolder ?? this.parentFolder,
      );
}
