import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class CompletionStep extends OnboardingStepWidget {
  final VoidCallback onComplete;

  const CompletionStep({
    super.key,
    required this.onComplete,
    super.onBack,
  }) : super(
          header: "You're all set!",
          subtext: "Let's find someone who matches your vibe.",
          canProceed: true,
        );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.favorite,
            size: 60,
            color: Color(0xFFE91E63),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          "Ready to discover amazing people?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: onComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Start Discovering',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}