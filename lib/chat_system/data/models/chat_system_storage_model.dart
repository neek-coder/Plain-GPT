import 'dart:collection';

import 'chat_system_object_data_model.dart';

final class ChatSystemDataModel {
  final List<ChatSystemObjectDataModel> _content = [];

  UnmodifiableListView<ChatSystemObjectDataModel> get content =>
      UnmodifiableListView(_content);

  ChatSystemDataModel({required List<ChatSystemObjectDataModel> content}) {
    _content.addAll(content);
  }
}
