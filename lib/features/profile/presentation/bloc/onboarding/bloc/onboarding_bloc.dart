import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ilike/core/network/hive_service.dart';
import 'package:ilike/features/profile/domain/entities/profile_entity.dart';
import 'package:ilike/features/profile/domain/usecases/save_profile_usecase.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SaveProfile saveProfile;
  static const int totalSteps = 9;

  OnboardingBloc({required this.saveProfile}) : super(OnboardingInitial()) {
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<UpdateName>(_onUpdateName);
    on<UpdateGender>(_onUpdateGender);
    on<UpdateLocation>(_onUpdateLocation);
    on<UpdateIntentions>(_onUpdateIntentions);
    on<UpdateAge>(_onUpdateAge);
    on<UpdateBio>(_onUpdateBio);
    on<UpdateInterests>(_onUpdateInterests);
    on<UpdateHeight>(_onUpdateHeight);
    on<UpdatePhotos>(_onUpdatePhotos);
    on<CompleteOnboarding>(_onCompleteOnboarding);
  }

  void _onNextStep(NextStep event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      if (currentState.currentStep < totalSteps) {
        emit(
          OnboardingInProgress(
            currentStep: currentState.currentStep + 1,
            data: currentState.data,
          ),
        );
      }
    } else {
      emit(
        const OnboardingInProgress(
          currentStep: 1,
          data: ProfileEntity(
            name: '',
            gender: '',
            location: '',
            intentions: <String>[],
            age: 0,
            bio: '',
            interests: <String>[],
            height: '',
            photoUrls: <String>[],
          ),
        ),
      );
    }
  }

  void _onPreviousStep(PreviousStep event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      if (currentState.currentStep > 1) {
        emit(
          OnboardingInProgress(
            currentStep: currentState.currentStep - 1,
            data: currentState.data,
          ),
        );
      }
    }
  }

  void _onUpdateName(UpdateName event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(name: event.name),
        ),
      );
    }
  }

  void _onUpdateGender(UpdateGender event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(gender: event.gender),
        ),
      );
    }
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(location: event.location),
        ),
      );
    }
  }

  void _onUpdateIntentions(
    UpdateIntentions event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(intentions: event.intentions),
        ),
      );
    }
  }

  void _onUpdateAge(UpdateAge event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(age: event.age),
        ),
      );
    }
  }

  void _onUpdateBio(UpdateBio event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(bio: event.bio),
        ),
      );
    }
  }

  void _onUpdateInterests(
    UpdateInterests event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(interests: event.interests),
        ),
      );
    }
  }

  void _onUpdateHeight(UpdateHeight event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(height: event.height),
        ),
      );
    }
  }

  void _onUpdatePhotos(UpdatePhotos event, Emitter<OnboardingState> emit) {
    if (state is OnboardingInProgress) {
      final currentState = state as OnboardingInProgress;
      emit(
        OnboardingInProgress(
          currentStep: currentState.currentStep,
          data: currentState.data.copyWith(photoUrls: event.photos),
        ),
      );
    }
  }

  bool _validateProfile(ProfileEntity profile) {
    if (profile.name.isEmpty) return false;
    if (profile.gender.isEmpty) return false;
    if (profile.location.isEmpty) return false;
    if (profile.intentions.isEmpty) return false;
    if (profile.age < 18) return false;
    if (profile.bio.isEmpty) return false;
    if (profile.interests.isEmpty) return false;
    if (profile.height.isEmpty) return false;
    if (profile.photoUrls.isEmpty) return false;

    return true;
  }

  void _onCompleteOnboarding(
    CompleteOnboarding event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is OnboardingInProgress) {
      try {
        // Check if user is logged in
        final isLoggedIn = await HiveService.isUserLoggedIn();
        final token = HiveService.getAuthToken();
        print(
          '[OnboardingBloc] Completing onboarding - isLoggedIn: $isLoggedIn, token: $token',
        );

        if (!isLoggedIn) {
          emit(OnboardingError('Please log in before completing onboarding'));
          return;
        }

        final currentState = state as OnboardingInProgress;

        // Validate profile data before saving
        if (!_validateProfile(currentState.data)) {
          emit(OnboardingError('Please complete all profile fields'));
          return;
        }

        emit(
          OnboardingInProgress(
            currentStep: currentState.currentStep,
            data: currentState.data,
          ),
        );

        await saveProfile(
          name: currentState.data.name,
          gender: currentState.data.gender,
          location: currentState.data.location,
          intentions: currentState.data.intentions,
          age: currentState.data.age,
          bio: currentState.data.bio,
          interests: currentState.data.interests,
          height: currentState.data.height,
          photoUrls: currentState.data.photoUrls,
        );
        emit(OnboardingCompleted());
      } catch (e) {
        emit(
          OnboardingError('Failed to save onboarding data: ${e.toString()}'),
        );
      }
    }
  }
}
