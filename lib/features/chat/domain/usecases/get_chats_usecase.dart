import 'package:dartz/dartz.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/core/usecase/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatsUseCase implements UsecaseWithoutParams<List<ChatEntity>> {
  final ChatRepository repository;

  GetChatsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call() async {
    return await repository.getChats();
  }
}
