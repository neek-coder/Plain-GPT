part of 'chat_system_bloc.dart';

@immutable
sealed class ChatSystemEvent {
  const ChatSystemEvent();
}

final class ChatSystemLoadEvent extends ChatSystemEvent {}

final class ChatSystemLoadedEvent extends ChatSystemEvent {
  final ChatSystemViewModel system;

  const ChatSystemLoadedEvent(this.system);
}

final class ChatSystemStoreEvent extends ChatSystemEvent {}

final class ChatSystemObjectAddEvent extends ChatSystemEvent {
  final ChatSystemObjectViewModel object;
  final ChatFolderViewModel? to;

  const ChatSystemObjectAddEvent({required this.object, this.to});
}

final class ChatObjectRemoveEvent extends ChatSystemEvent {
  final ChatSystemObjectViewModel object;
  final ChatFolderViewModel? from;

  const ChatObjectRemoveEvent({required this.object, this.from});
}

final class ChatObjectMoveEvent extends ChatSystemEvent {
  final ChatSystemObjectViewModel object;
  final ChatFolderViewModel? from;
  final ChatFolderViewModel? to;

  const ChatObjectMoveEvent({
    required this.object,
    this.from,
    this.to,
  });
}

final class ChatObjectInsertAboveEvent extends ChatSystemEvent {
  final ChatSystemObjectViewModel object;
  final ChatSystemObjectViewModel anchor;

  const ChatObjectInsertAboveEvent({
    required this.object,
    required this.anchor,
  });
}

final class ChatObjectInsertBelowEvent extends ChatSystemEvent {
  final ChatSystemObjectViewModel object;
  final ChatSystemObjectViewModel anchor;

  const ChatObjectInsertBelowEvent({
    required this.object,
    required this.anchor,
  });
}

final class ChatSelectEvent extends ChatSystemEvent {
  final ChatViewModel chat;

  const ChatSelectEvent(this.chat);
}

final class ChatUnselectEvent extends ChatSystemEvent {}
