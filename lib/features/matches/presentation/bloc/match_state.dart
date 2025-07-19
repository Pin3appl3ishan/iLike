part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object?> get props => [];
}

class MatchInitialState extends MatchState {}

class MatchLoadingState extends MatchState {}

class MatchLoadedState extends MatchState {
  final List<PotentialMatchEntity> profiles;
  final int currentIndex;

  const MatchLoadedState({
    required this.profiles,
    this.currentIndex = 0,
  });

  @override
  List<Object?> get props => [profiles, currentIndex];

  MatchLoadedState copyWith({
    List<PotentialMatchEntity>? profiles,
    int? currentIndex,
  }) {
    return MatchLoadedState(
      profiles: profiles ?? this.profiles,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}

class MatchesLoadedState extends MatchState {
  final List<MatchEntity> matches;

  const MatchesLoadedState({required this.matches});

  @override
  List<Object?> get props => [matches];
}

class MatchSuccessState extends MatchState {
  final String matchedUserId;

  const MatchSuccessState({required this.matchedUserId});

  @override
  List<Object?> get props => [matchedUserId];
}

class MatchErrorState extends MatchState {
  final String message;

  const MatchErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
