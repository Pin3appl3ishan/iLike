part of 'onboarding_bloc.dart';

sealed class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class NextStep extends OnboardingEvent {}

class PreviousStep extends OnboardingEvent {}

class UpdateName extends OnboardingEvent {
  final String name;
  const UpdateName(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdateGender extends OnboardingEvent {
  final String gender;
  const UpdateGender(this.gender);

  @override
  List<Object?> get props => [gender];
}

class UpdateLocation extends OnboardingEvent {
  final String location;
  const UpdateLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class UpdateIntentions extends OnboardingEvent {
  final List<String> intentions;
  const UpdateIntentions(this.intentions);

  @override
  List<Object?> get props => [intentions];
}

class UpdateAge extends OnboardingEvent {
  final int age;
  const UpdateAge(this.age);

  @override
  List<Object?> get props => [age];
}

class UpdateBio extends OnboardingEvent {
  final String bio;
  const UpdateBio(this.bio);

  @override
  List<Object?> get props => [bio];
}

class UpdateInterests extends OnboardingEvent {
  final List<String> interests;
  const UpdateInterests(this.interests);

  @override
  List<Object?> get props => [interests];
}

class UpdateHeight extends OnboardingEvent {
  final String height;
  const UpdateHeight(this.height);

  @override
  List<Object?> get props => [height];
}

class UpdatePhotos extends OnboardingEvent {
  final List<String> photos;
  const UpdatePhotos(this.photos);

  @override
  List<Object?> get props => [photos];
}

class CompleteOnboarding extends OnboardingEvent {}