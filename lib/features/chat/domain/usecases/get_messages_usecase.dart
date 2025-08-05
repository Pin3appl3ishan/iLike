import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesParams {
  final String chatId;

  GetMessagesParams(this.chatId);
}

class GetMessagesUseCase
    implements UsecaseWithParams<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(
      GetMessagesParams params) async {
    return await repository.getMessages(params.chatId);
  }
}
