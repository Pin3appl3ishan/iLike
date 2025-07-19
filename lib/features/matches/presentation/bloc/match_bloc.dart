import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/error/failures.dart';
import 'package:ilike/features/matches/domain/usecases/get_potential_matches_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/like_user_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/dislike_user_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/get_matches_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/get_likes_usecase.dart';
import 'package:ilike/features/matches/domain/usecases/get_likes_sent_usecase.dart';
import 'package:ilike/features/matches/domain/entities/potential_match_entity.dart';
import 'package:ilike/features/matches/domain/entities/match_entity.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final GetPotentialMatchesUseCase getPotentialMatches;
  final LikeUserUseCase likeUser;
  final DislikeUserUseCase dislikeUser;
  final GetMatchesUseCase getMatches;
  final GetLikesUseCase getLikes;
  final GetLikesSentUseCase getLikesSent;

  MatchBloc({
    required this.getPotentialMatches,
    required this.likeUser,
    required this.dislikeUser,
    required this.getMatches,
    required this.getLikes,
    required this.getLikesSent,
  }) : super(const MatchLoadedState(profiles: [], currentIndex: 0)) {
    on<LoadPotentialMatchesEvent>(_onLoadPotentialMatches);
    on<LikeUserEvent>(_onLikeUser);
    on<DislikeUserEvent>(_onDislikeUser);
    on<NextProfileEvent>(_onNextProfile);
    on<LoadMatchesEvent>(_onLoadMatches);
    on<LoadLikesEvent>(_onLoadLikes);
    on<LoadLikesSentEvent>(_onLoadLikesSent);
  }

  Future<void> _onLoadPotentialMatches(
    LoadPotentialMatchesEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoadingState());

    final result = await getPotentialMatches();
    result.fold(
      (failure) =>
          emit(MatchErrorState(message: _mapFailureToMessage(failure))),
      (profiles) => emit(MatchLoadedState(profiles: profiles)),
    );
  }

  Future<void> _onLikeUser(
    LikeUserEvent event,
    Emitter<MatchState> emit,
  ) async {
    if (state is! MatchLoadedState) return;
    final currentState = state as MatchLoadedState;

    final result = await likeUser(event.userId);
    await result.fold(
      (failure) async {
        emit(MatchErrorState(message: _mapFailureToMessage(failure)));
        emit(currentState); // Revert to previous state
      },
      (isMatch) async {
        if (isMatch) {
          emit(MatchSuccessState(matchedUserId: event.userId));
          emit(currentState); // Return to swiping state after match
        }
        // Move to next profile
        if (currentState.currentIndex < currentState.profiles.length - 1) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex + 1,
          ));
        } else {
          // Load more profiles if needed
          add(LoadPotentialMatchesEvent());
        }
      },
    );
  }

  Future<void> _onDislikeUser(
    DislikeUserEvent event,
    Emitter<MatchState> emit,
  ) async {
    if (state is! MatchLoadedState) return;
    final currentState = state as MatchLoadedState;

    final result = await dislikeUser(event.userId);
    result.fold(
      (failure) {
        emit(MatchErrorState(message: _mapFailureToMessage(failure)));
        emit(currentState); // Revert to previous state
      },
      (_) {
        // Move to next profile
        if (currentState.currentIndex < currentState.profiles.length - 1) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex + 1,
          ));
        } else {
          // Load more profiles if needed
          add(LoadPotentialMatchesEvent());
        }
      },
    );
  }

  void _onNextProfile(
    NextProfileEvent event,
    Emitter<MatchState> emit,
  ) {
    if (state is! MatchLoadedState) return;
    final currentState = state as MatchLoadedState;

    if (currentState.currentIndex < currentState.profiles.length - 1) {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
      ));
    } else {
      // Load more profiles if needed
      add(LoadPotentialMatchesEvent());
    }
  }

  Future<void> _onLoadMatches(
    LoadMatchesEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoadingState());

    final result = await getMatches();
    result.fold(
      (failure) =>
          emit(MatchErrorState(message: _mapFailureToMessage(failure))),
      (matches) => emit(MatchesLoadedState(matches: matches)),
    );
  }

  Future<void> _onLoadLikes(
    LoadLikesEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoadingState());

    final result = await getLikes();
    result.fold(
      (failure) =>
          emit(MatchErrorState(message: _mapFailureToMessage(failure))),
      (profiles) => emit(MatchLoadedState(profiles: profiles)),
    );
  }

  Future<void> _onLoadLikesSent(
    LoadLikesSentEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(MatchLoadingState());

    final result = await getLikesSent();
    result.fold(
      (failure) =>
          emit(MatchErrorState(message: _mapFailureToMessage(failure))),
      (profiles) => emit(MatchLoadedState(profiles: profiles)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return 'Server error. Please try again later.';
      case CacheFailure _:
        return 'Cache error. Please try again.';
      case UnauthorizedFailure _:
        return 'Unauthorized. Please log in again.';
      default:
        return 'An unexpected error occurred';
    }
  }
}
