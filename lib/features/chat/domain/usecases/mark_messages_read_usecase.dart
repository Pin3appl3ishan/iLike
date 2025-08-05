import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import '../repositories/chat_repository.dart';

class MarkMessagesReadParams {
  final String chatId;

  MarkMessagesReadParams(this.chatId);
}

class MarkMessagesReadUseCase
    implements UsecaseWithParams<Unit, MarkMessagesReadParams> {
  final ChatRepository repository;

  MarkMessagesReadUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(MarkMessagesReadParams params) async {
    return await repository.markMessagesAsRead(params.chatId);
  }
}
