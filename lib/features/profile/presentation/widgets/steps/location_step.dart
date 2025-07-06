import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class LocationStep extends OnboardingStepWidget {
  final String? initialValue;
  final Function(String) onChanged;

  LocationStep({
    super.key,
    required this.onChanged,
    this.initialValue,
    super.onNext,
    super.onBack,
  }) : super(
          header: "Where do you live?",
          subtext: "Helps us find nearby matches.",
          canProceed: initialValue?.isNotEmpty == true,
        );

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: initialValue),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'City, Country',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: const Icon(Icons.location_on, color: Colors.grey),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
      ],
    );
  }
}