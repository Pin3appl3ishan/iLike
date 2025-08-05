import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:ilike/features/chat/domain/entities/message_entity.dart';

class SocketService {
  static SocketService? _instance;
  static SocketService get instance => _instance ??= SocketService._internal();

  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  String? _currentUserId;

  // Stream controllers for real-time updates
  final StreamController<MessageEntity> _messageController =
      StreamController<MessageEntity>.broadcast();
  final StreamController<Map<String, dynamic>> _typingController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _readController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _chatUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _connectionController =
      StreamController<String>.broadcast();

  // Streams for UI to listen to
  Stream<MessageEntity> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;
  Stream<Map<String, dynamic>> get readStream => _readController.stream;
  Stream<Map<String, dynamic>> get chatUpdateStream =>
      _chatUpdateController.stream;
  Stream<String> get connectionStream => _connectionController.stream;

  bool get isConnected => _isConnected;
  String? get currentUserId => _currentUserId;

  Future<void> connect(String token, String userId) async {
    if (_isConnected && _currentUserId == userId) {
      return; // Already connected
    }

    // Disconnect existing connection if any
    await disconnect();

    _currentUserId = userId;

    try {
      _socket = IO.io(
        'http://localhost:5000', // Your backend URL
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(5000)
            .setTimeout(20000)
            .setAuth({'token': token})
            .build(),
      );

      _setupEventListeners();
      _socket!.connect();
    } catch (e) {
      print('Error connecting to socket: $e');
      _connectionController.add('error');
    }
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    _socket!.onConnect((_) {
      print('Socket connected');
      _isConnected = true;
      _connectionController.add('connected');
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected');
      _isConnected = false;
      _connectionController.add('disconnected');
    });

    _socket!.onConnectError((error) {
      print('Socket connection error: $error');
      _isConnected = false;
      _connectionController.add('error');
    });

    // Handle new messages
    _socket!.on('new_message', (data) {
      try {
        final message = MessageEntity(
          messageId: data['messageId'],
          chatId: data['chatId'],
          senderId: data['senderId'],
          content: data['content'],
          type: MessageType.values.firstWhere(
            (e) => e.name == data['type'],
            orElse: () => MessageType.text,
          ),
          status: MessageStatus.values.firstWhere(
            (e) => e.name == data['status'],
            orElse: () => MessageStatus.sent,
          ),
          timestamp: DateTime.parse(data['timestamp']),
          isFromMe: false,
        );
        _messageController.add(message);
      } catch (e) {
        print('Error parsing new message: $e');
      }
    });

    // Handle message sent confirmation
    _socket!.on('message_sent', (data) {
      try {
        final message = MessageEntity(
          messageId: data['messageId'],
          chatId: data['chatId'],
          senderId: data['senderId'],
          content: data['content'],
          type: MessageType.values.firstWhere(
            (e) => e.name == data['type'],
            orElse: () => MessageType.text,
          ),
          status: MessageStatus.values.firstWhere(
            (e) => e.name == data['status'],
            orElse: () => MessageStatus.sent,
          ),
          timestamp: DateTime.parse(data['timestamp']),
          isFromMe: true,
        );
        _messageController.add(message);
      } catch (e) {
        print('Error parsing message sent: $e');
      }
    });

    // Handle typing indicators
    _socket!.on('user_typing', (data) {
      _typingController.add(data);
    });

    // Handle read receipts
    _socket!.on('messages_read', (data) {
      _readController.add(data);
    });

    // Handle chat updates
    _socket!.on('chat_updated', (data) {
      _chatUpdateController.add(data);
    });

    // Handle message errors
    _socket!.on('message_error', (data) {
      print('Message error: ${data['message']}');
    });
  }

  // Join a chat room
  void joinChat(String chatId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('join_chat', chatId);
      print('Joined chat: $chatId');
    }
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('leave_chat', chatId);
      print('Left chat: $chatId');
    }
  }

  // Send a message
  void sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
  }) {
    if (_socket != null && _isConnected) {
      _socket!.emit('send_message', {
        'chatId': chatId,
        'content': content,
        'type': type.name,
      });
    }
  }

  // Start typing indicator
  void startTyping(String chatId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('typing_start', {'chatId': chatId});
    }
  }

  // Stop typing indicator
  void stopTyping(String chatId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('typing_stop', {'chatId': chatId});
    }
  }

  // Mark messages as read
  void markMessagesAsRead(String chatId) {
    if (_socket != null && _isConnected) {
      _socket!.emit('mark_read', {'chatId': chatId});
    }
  }

  // Disconnect from socket
  Future<void> disconnect() async {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
    }
    _isConnected = false;
    _currentUserId = null;
  }

  // Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _readController.close();
    _chatUpdateController.close();
    _connectionController.close();
  }
}
