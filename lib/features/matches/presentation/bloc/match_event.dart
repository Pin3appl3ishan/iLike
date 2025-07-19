part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadPotentialMatchesEvent extends MatchEvent {}

class LikeUserEvent extends MatchEvent {
  final String userId;
  const LikeUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DislikeUserEvent extends MatchEvent {
  final String userId;
  const DislikeUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class NextProfileEvent extends MatchEvent {}

class LoadMatchesEvent extends MatchEvent {}

class LoadLikesEvent extends MatchEvent {}

class LoadLikesSentEvent extends MatchEvent {}
