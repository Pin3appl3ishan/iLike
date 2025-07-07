import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ilike/features/profile/domain/entities/profile_entity.dart';
import 'package:ilike/features/profile/presentation/bloc/onboarding/bloc/onboarding_bloc.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/about_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/completion_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/gender_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/height_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/intention_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/interests_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/location_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/name_step.dart';
import 'package:ilike/features/profile/presentation/widgets/steps/photos_step.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingCompleted) {
          // Navigate to main app
          Navigator.of(context).pushReplacementNamed('/main');
        } else if (state is OnboardingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is! OnboardingInProgress) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bloc = context.read<OnboardingBloc>();
        final currentStep = state.currentStep;
        final data = state.data;

        return Scaffold(
          body: Column(
            children: [
              // Progress indicator
              Container(
                padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
                child: LinearProgressIndicator(
                  value: currentStep / OnboardingBloc.totalSteps,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFE91E63),
                  ),
                ),
              ),
              Expanded(
                child: _buildCurrentStep(context, bloc, currentStep, data),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    OnboardingBloc bloc,
    int currentStep,
    ProfileEntity data,
  ) {
    switch (currentStep) {
      case 1:
        return NameStep(
          initialValue: data.name,
          onChanged: (name) => bloc.add(UpdateName(name)),
          onNext: () => bloc.add(NextStep()),
        );
      
      case 2:
        return GenderStep(
          selectedGender: data.gender,
          onChanged: (gender) => bloc.add(UpdateGender(gender)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 3:
        return LocationStep(
          initialValue: data.location,
          onChanged: (location) => bloc.add(UpdateLocation(location)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 4:
        return IntentionsStep(
          selectedIntentions: data.intentions,
          onChanged: (intentions) => bloc.add(UpdateIntentions(intentions)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 5:
        return AboutStep(
          age: data.age,
          bio: data.bio,
          onAgeChanged: (age) => bloc.add(UpdateAge(age)),
          onBioChanged: (bio) => bloc.add(UpdateBio(bio)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 6:
        return InterestsStep(
          selectedInterests: data.interests,
          onChanged: (interests) => bloc.add(UpdateInterests(interests)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 7:
        return HeightStep(
          selectedHeight: data.height,
          onChanged: (height) => bloc.add(UpdateHeight(height)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 8:
        return PhotosStep(
          photos: data.photoUrls,
          onChanged: (photos) => bloc.add(UpdatePhotos(photos)),
          onNext: () => bloc.add(NextStep()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      case 9:
        return CompletionStep(
          onComplete: () => bloc.add(CompleteOnboarding()),
          onBack: () => bloc.add(PreviousStep()),
        );
      
      default:
        return const SizedBox();
    }
  }
}