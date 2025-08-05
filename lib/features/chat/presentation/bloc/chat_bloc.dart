import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/network/socket_service.dart';
import 'package:ilike/features/chat/domain/usecases/get_chats_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:ilike/features/chat/domain/usecases/mark_messages_read_usecase.dart';
import 'package:ilike/features/chat/domain/entities/chat_entity.dart';
import 'package:ilike/features/chat/domain/entities/message_entity.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChatsUseCase getChats;
  final GetMessagesUseCase getMessages;
  final SendMessageUseCase sendMessage;
  final MarkMessagesReadUseCase markMessagesRead;
  final SocketService socketService = SocketService.instance;
  final AuthBloc authBloc;

  late final StreamSubscription<MessageEntity> _messageSub;
  late final StreamSubscription<Map<String, dynamic>> _typingSub;
  late final StreamSubscription<Map<String, dynamic>> _readSub;
  late final StreamSubscription<Map<String, dynamic>> _chatUpdateSub;
  late final StreamSubscription<String> _connectionSub;

  ChatBloc({
    required this.getChats,
    required this.getMessages,
    required this.sendMessage,
    required this.markMessagesRead,
    required this.authBloc,
  }) : super(ChatInitialState()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkMessagesReadEvent>(_onMarkMessagesRead);
    on<JoinChatEvent>(_onJoinChat);
    on<LeaveChatEvent>(_onLeaveChat);
    on<StartTypingEvent>(_onStartTyping);
    on<StopTypingEvent>(_onStopTyping);
    on<ConnectSocketEvent>(_onConnectSocket);
    on<RetryFailedMessageEvent>(_onRetryFailedMessage);
    on<DisconnectSocketEvent>(_onDisconnectSocket);
    // New socket events
    on<SocketMessageReceivedEvent>(_onSocketMessageReceived);
    on<SocketTypingEvent>(_onSocketTyping);
    on<SocketReadEvent>(_onSocketRead);
    on<SocketChatUpdateEvent>(_onSocketChatUpdate);
    on<SocketConnectionEvent>(_onSocketConnection);

    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _messageSub = socketService.messageStream.listen((message) {
      add(SocketMessageReceivedEvent(message));
    });
    _typingSub = socketService.typingStream.listen((data) {
      add(SocketTypingEvent(data));
    });
    _readSub = socketService.readStream.listen((data) {
      add(SocketReadEvent(data));
    });
    _chatUpdateSub = socketService.chatUpdateStream.listen((data) {
      add(SocketChatUpdateEvent(data));
    });
    _connectionSub = socketService.connectionStream.listen((status) {
      add(SocketConnectionEvent(status));
    });
  }

  // Socket event handlers
  void _onSocketMessageReceived(
      SocketMessageReceivedEvent event, Emitter<ChatState> emit) {
    if (state is MessagesLoadedState) {
      final currentState = state as MessagesLoadedState;
      final updatedMessages = [...currentState.messages, event.message];
      emit(MessagesLoadedState(messages: updatedMessages));
    }
  }

  void _onSocketTyping(SocketTypingEvent event, Emitter<ChatState> emit) {
    emit(ChatTypingState(
      userId: event.data['userId'],
      chatId: event.data['chatId'],
      isTyping: event.data['isTyping'],
    ));
  }

  void _onSocketRead(SocketReadEvent event, Emitter<ChatState> emit) {
    if (state is MessagesLoadedState) {
      final currentState = state as MessagesLoadedState;
      final updatedMessages = currentState.messages.map((msg) {
        if (msg.chatId == event.data['chatId'] && !msg.isFromMe) {
          return msg.copyWith(status: MessageStatus.read);
        }
        return msg;
      }).toList();
      emit(MessagesLoadedState(messages: updatedMessages));
    }
  }

  void _onSocketChatUpdate(
      SocketChatUpdateEvent event, Emitter<ChatState> emit) {
    add(LoadChatsEvent());
  }

  void _onSocketConnection(
      SocketConnectionEvent event, Emitter<ChatState> emit) {
    emit(ChatConnectionState(status: event.status));
  }

  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());

    final result = await getChats();
    result.fold(
      (failure) => emit(ChatErrorState(message: _mapFailureToMessage(failure))),
      (chats) => emit(ChatsLoadedState(chats: chats)),
    );
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());

    final result = await getMessages(GetMessagesParams(event.chatId));
    result.fold(
      (failure) => emit(ChatErrorState(message: _mapFailureToMessage(failure))),
      (messages) => emit(MessagesLoadedState(messages: messages)),
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is MessagesLoadedState) {
      final currentState = state as MessagesLoadedState;

      // Create optimistic message
      final optimisticMessage = MessageEntity(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: event.chatId,
        senderId: 'current_user', // This should come from auth
        content: event.content,
        type: event.type,
        status: MessageStatus.sending,
        timestamp: DateTime.now(),
        isFromMe: true,
      );

      // Add optimistic message to UI
      final updatedMessages = [...currentState.messages, optimisticMessage];
      emit(MessagesLoadedState(messages: updatedMessages));

      // Send via Socket.IO for real-time delivery
      socketService.sendMessage(
        chatId: event.chatId,
        content: event.content,
        type: event.type,
      );

      // Also send via REST API as backup
      final result = await sendMessage(SendMessageParams(
        chatId: event.chatId,
        content: event.content,
        type: event.type,
      ));

      result.fold(
        (failure) {
          // Update message status to failed
          final failedMessage =
              optimisticMessage.copyWith(status: MessageStatus.failed);
          final updatedMessages = currentState.messages.map((msg) {
            return msg.messageId == optimisticMessage.messageId
                ? failedMessage
                : msg;
          }).toList();
          emit(MessagesLoadedState(messages: updatedMessages));
          emit(ChatErrorState(message: _mapFailureToMessage(failure)));
        },
        (sentMessage) {
          // Replace optimistic message with server response
          final updatedMessages = currentState.messages.map((msg) {
            return msg.messageId == optimisticMessage.messageId
                ? sentMessage
                : msg;
          }).toList();
          emit(MessagesLoadedState(messages: updatedMessages));
        },
      );
    }
  }

  Future<void> _onRetryFailedMessage(
    RetryFailedMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! MessagesLoadedState) return;

    final currentState = state as MessagesLoadedState;
    final failedMessage = currentState.messages
        .firstWhere((msg) => msg.messageId == event.messageId);

    // Create new send message event
    final sendEvent = SendMessageEvent(
      chatId: failedMessage.chatId,
      content: failedMessage.content,
      type: failedMessage.type,
    );

    // Remove failed message and retry
    final messagesWithoutFailed = currentState.messages
        .where((msg) => msg.messageId != event.messageId)
        .toList();

    emit(MessagesLoadedState(messages: messagesWithoutFailed));
    add(sendEvent);
  }

  Future<void> _onMarkMessagesRead(
    MarkMessagesReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Mark as read via Socket.IO for real-time updates
    socketService.markMessagesAsRead(event.chatId);

    // Also mark via REST API as backup
    final result = await markMessagesRead(MarkMessagesReadParams(event.chatId));
    result.fold(
      (failure) => emit(ChatErrorState(message: _mapFailureToMessage(failure))),
      (_) {
        // Update messages to mark them as read
        if (state is MessagesLoadedState) {
          final currentState = state as MessagesLoadedState;
          final updatedMessages = currentState.messages.map((msg) {
            if (!msg.isFromMe && msg.status != MessageStatus.read) {
              return msg.copyWith(status: MessageStatus.read);
            }
            return msg;
          }).toList();
          emit(MessagesLoadedState(messages: updatedMessages));
        }
      },
    );
  }

  void _onJoinChat(JoinChatEvent event, Emitter<ChatState> emit) {
    socketService.joinChat(event.chatId);
  }

  void _onLeaveChat(LeaveChatEvent event, Emitter<ChatState> emit) {
    socketService.leaveChat(event.chatId);
  }

  void _onStartTyping(StartTypingEvent event, Emitter<ChatState> emit) {
    socketService.startTyping(event.chatId);
  }

  void _onStopTyping(StopTypingEvent event, Emitter<ChatState> emit) {
    socketService.stopTyping(event.chatId);
  }

  Future<void> _onConnectSocket(
      ConnectSocketEvent event, Emitter<ChatState> emit) async {
    await socketService.connect(event.token, event.userId);
  }

  Future<void> _onDisconnectSocket(
      DisconnectSocketEvent event, Emitter<ChatState> emit) async {
    await socketService.disconnect();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return 'Server error. Please try again later.';
      case CacheFailure _:
        return 'Cache error. Please try again.';
      case UnauthorizedFailure _:
        return 'Unauthorized. Please log in again.';
      case NetworkFailure _:
        return 'Network error. Please check your internet connection.';
      default:
        return 'An unexpected error occurred';
    }
  }

  @override
  Future<void> close() {
    _messageSub.cancel();
    _typingSub.cancel();
    _readSub.cancel();
    _chatUpdateSub.cancel();
    _connectionSub.cancel();
    socketService.dispose();
    return super.close();
  }
}
