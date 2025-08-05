import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String chatId;
  final String content;
  final MessageType type;

  SendMessageParams({
    required this.chatId,
    required this.content,
    required this.type,
  });
}

class SendMessageUseCase
    implements UsecaseWithParams<MessageEntity, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      chatId: params.chatId,
      content: params.content,
      type: params.type,
    );
  }
}
