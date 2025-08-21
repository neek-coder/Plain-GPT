part of 'chat_content_bloc.dart';

sealed class ChatContentState {
  const ChatContentState();
}

final class ChatContentInitial extends ChatContentState {}

final class ChatContentLoading extends ChatContentState {
  final ChatViewModel chat;
  const ChatContentLoading(this.chat);
}

final class ChatContentLoaded extends ChatContentState {
  final ChatContentViewModel content;
  final ChatViewModel chat;

  const ChatContentLoaded({required this.content, required this.chat});
}

final class QuickChat extends ChatContentState {
  final ChatContentViewModel content;

  const QuickChat({required this.content});
}

// final class ChatContentError extends ChatContentState {
//   final String message;

//   const ChatContentError({required this.message});
// }
