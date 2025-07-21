import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // Get all chats for current user
  Future<Either<Failure, List<ChatEntity>>> getChats();

  // Get messages for a specific chat
  Future<Either<Failure, List<MessageEntity>>> getMessages(String chatId);

  // Send a message
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
  });

  // Mark messages as read
  Future<Either<Failure, Unit>> markMessagesAsRead(String chatId);

  // Create a new chat (when first message is sent)
  Future<Either<Failure, ChatEntity>> createChat(String otherUserId);

  // Get chat by ID
  Future<Either<Failure, ChatEntity>> getChatById(String chatId);

  // Delete a chat
  Future<Either<Failure, Unit>> deleteChat(String chatId);
}
