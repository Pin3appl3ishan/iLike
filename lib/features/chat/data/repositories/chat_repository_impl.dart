import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/error/exceptions.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final chats = await remoteDataSource.getChats();
      return Right(chats);
    } on ServerException {
      return Left(const ServerFailure('Failed to load chats'));
    } catch (e) {
      return Left(ServerFailure('Failed to load chats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages);
    } on ServerException {
      return Left(const ServerFailure('Failed to load messages'));
    } catch (e) {
      return Left(ServerFailure('Failed to load messages: $e'));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String chatId,
    required String content,
    required MessageType type,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        chatId: chatId,
        content: content,
        type: type,
      );
      return Right(message);
    } on ServerException {
      return Left(const ServerFailure('Failed to send message'));
    } catch (e) {
      return Left(ServerFailure('Failed to send message: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markMessagesAsRead(String chatId) async {
    try {
      await remoteDataSource.markMessagesAsRead(chatId);
      return const Right(unit);
    } on ServerException {
      return Left(const ServerFailure('Failed to mark messages as read'));
    } catch (e) {
      return Left(ServerFailure('Failed to mark messages as read: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createChat(String otherUserId) async {
    try {
      final chat = await remoteDataSource.createChat(otherUserId);
      return Right(chat);
    } on ServerException {
      return Left(const ServerFailure('Failed to create chat'));
    } catch (e) {
      return Left(ServerFailure('Failed to create chat: $e'));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChatById(String chatId) async {
    try {
      final chat = await remoteDataSource.getChatById(chatId);
      return Right(chat);
    } on ServerException {
      return Left(const ServerFailure('Failed to get chat'));
    } catch (e) {
      return Left(ServerFailure('Failed to get chat: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) async {
    try {
      await remoteDataSource.deleteChat(chatId);
      return const Right(unit);
    } on ServerException {
      return Left(const ServerFailure('Failed to delete chat'));
    } catch (e) {
      return Left(ServerFailure('Failed to delete chat: $e'));
    }
  }
}
