part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatsEvent extends ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;

  const LoadMessagesEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;
  final MessageType type;

  const SendMessageEvent({
    required this.chatId,
    required this.content,
    required this.type,
  });

  @override
  List<Object?> get props => [chatId, content, type];
}

class RetryFailedMessageEvent extends ChatEvent {
  final String messageId;

  const RetryFailedMessageEvent(this.messageId);

  @override
  List<Object> get props => [messageId];
}

class MarkMessagesReadEvent extends ChatEvent {
  final String chatId;

  const MarkMessagesReadEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class JoinChatEvent extends ChatEvent {
  final String chatId;

  const JoinChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class LeaveChatEvent extends ChatEvent {
  final String chatId;

  const LeaveChatEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class StartTypingEvent extends ChatEvent {
  final String chatId;

  const StartTypingEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class StopTypingEvent extends ChatEvent {
  final String chatId;

  const StopTypingEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class ConnectSocketEvent extends ChatEvent {
  final String token;
  final String userId;

  const ConnectSocketEvent({
    required this.token,
    required this.userId,
  });

  @override
  List<Object?> get props => [token, userId];
}

class DisconnectSocketEvent extends ChatEvent {}

// Socket events for stream subscriptions
class SocketMessageReceivedEvent extends ChatEvent {
  final MessageEntity message;
  const SocketMessageReceivedEvent(this.message);
  @override
  List<Object?> get props => [message];
}

class SocketTypingEvent extends ChatEvent {
  final Map<String, dynamic> data;
  const SocketTypingEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SocketReadEvent extends ChatEvent {
  final Map<String, dynamic> data;
  const SocketReadEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SocketChatUpdateEvent extends ChatEvent {
  final Map<String, dynamic> data;
  const SocketChatUpdateEvent(this.data);
  @override
  List<Object?> get props => [data];
}

class SocketConnectionEvent extends ChatEvent {
  final String status;
  const SocketConnectionEvent(this.status);
  @override
  List<Object?> get props => [status];
}
