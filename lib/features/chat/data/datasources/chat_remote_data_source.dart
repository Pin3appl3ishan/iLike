import 'package:ilike/core/network/api_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../../domain/entities/message_entity.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
  });
  Future<void> markMessagesAsRead(String chatId);
  Future<ChatModel> createChat(String otherUserId);
  Future<ChatModel> getChatById(String chatId);
  Future<void> deleteChat(String chatId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiService apiService;

  ChatRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ChatModel>> getChats() async {
    try {
      final response = await apiService.dio.get('/chats');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ChatModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      throw Exception('Failed to load chats: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    try {
      final response = await apiService.dio.get('/chats/$chatId/messages');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MessageModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      throw Exception('Failed to load messages: $e');
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
  }) async {
    try {
      final response = await apiService.dio.post(
        '/chats/$chatId/messages',
        data: {
          'content': content,
          'type': type.name,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        return MessageModel.fromJson(data);
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final response = await apiService.dio.put('/chats/$chatId/read');

      if (response.statusCode != 200) {
        throw Exception('Failed to mark messages as read');
      }
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  @override
  Future<ChatModel> createChat(String otherUserId) async {
    try {
      final response = await apiService.dio.post(
        '/chats',
        data: {
          'otherUserId': otherUserId,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        return ChatModel.fromJson(data);
      } else {
        throw Exception('Failed to create chat');
      }
    } catch (e) {
      throw Exception('Failed to create chat: $e');
    }
  }

  @override
  Future<ChatModel> getChatById(String chatId) async {
    try {
      final response = await apiService.dio.get('/chats/$chatId');

      if (response.statusCode == 200) {
        final data = response.data;
        return ChatModel.fromJson(data);
      } else {
        throw Exception('Failed to get chat');
      }
    } catch (e) {
      throw Exception('Failed to get chat: $e');
    }
  }

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      final response = await apiService.dio.delete('/chats/$chatId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete chat');
      }
    } catch (e) {
      throw Exception('Failed to delete chat: $e');
    }
  }
}
