part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatsLoadedState extends ChatState {
  final List<ChatEntity> chats;

  const ChatsLoadedState({required this.chats});

  @override
  List<Object?> get props => [chats];
}

class MessagesLoadedState extends ChatState {
  final List<MessageEntity> messages;

  const MessagesLoadedState({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ChatTypingState extends ChatState {
  final String userId;
  final String chatId;
  final bool isTyping;

  const ChatTypingState({
    required this.userId,
    required this.chatId,
    required this.isTyping,
  });

  @override
  List<Object?> get props => [userId, chatId, isTyping];
}

class ChatConnectionState extends ChatState {
  final String status; // 'connected', 'disconnected', 'error', 'connecting', 'reconnecting'

  const ChatConnectionState({required this.status});

  @override
  List<Object?> get props => [status];
}
