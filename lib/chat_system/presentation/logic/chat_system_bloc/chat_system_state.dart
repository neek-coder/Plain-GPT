part of 'chat_system_bloc.dart';

@immutable
sealed class ChatSystemState {
  const ChatSystemState();
}

final class ChatSystemInitial extends ChatSystemState {}

final class ChatSystemLoaded extends ChatSystemState {
  final ChatSystemViewModel system;
  final ChatViewModel? selectedChat;

  const ChatSystemLoaded({required this.system, this.selectedChat});
}

final class ChatSystemError extends ChatSystemState {}
