import 'dart:collection';

import '../../domain/entities/chat_system_entity.dart';

sealed class ChatSystemObjectDataModel {
  final int id;
  final String name;
  final int? parentFolderId;
  final int layer;

  const ChatSystemObjectDataModel({
    required this.id,
    required this.name,
    required this.parentFolderId,
    required this.layer,
  });

  static int getLayer(ChatSystemObjectEntity object) {
    var l = 0;
    var folder = object.parentFolder;

    while (folder != null) {
      folder = folder.parentFolder;
      l += 1;
    }

    // The root folder is not included
    return l - 1;
  }
}

final class ChatDataModel extends ChatSystemObjectDataModel {
  const ChatDataModel({
    required super.id,
    required super.name,
    required super.parentFolderId,
    required super.layer,
  });

  ChatDataModel.fromEntity(ChatEntity chat)
      : super(
          id: chat.id,
          name: chat.name,
          parentFolderId: chat.parentFolder?.id,
          layer: ChatSystemObjectDataModel.getLayer(chat),
        );

  /// Converts to the [ChatEntity] entity without setting [ChatEntity.parentFolder] parameter
  ChatEntity toEntity() => ChatEntity(id: id, name: name);
}

final class ChatFolderDataModel extends ChatSystemObjectDataModel {
  final List<int> _children;

  UnmodifiableListView<int> get children => UnmodifiableListView(_children);

  ChatFolderDataModel({
    required super.id,
    required super.name,
    required super.parentFolderId,
    required super.layer,
    required List<int> children,
  }) : _children = children;

  ChatFolderDataModel.fromEntity(ChatFolderEntity folder)
      : _children = [],
        super(
          id: folder.id,
          name: folder.name,
          parentFolderId: folder.parentFolder?.id,
          layer: ChatSystemObjectDataModel.getLayer(folder),
        ) {
    _children.addAll(folder.children.map((e) => e.id));
  }

  /// Converts to the [ChatFolderEntity] entity without setting [ChatFolderEntity.parentFolder] and [ChatFolderEntity._children] parameters
  ChatFolderEntity toEntity() => ChatFolderEntity(id: id, name: name);
}
