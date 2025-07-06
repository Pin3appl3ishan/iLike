import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class IntentionsStep extends OnboardingStepWidget {
  final List<String> selectedIntentions;
  final Function(List<String>) onChanged;

  IntentionsStep({
    super.key,
    required this.onChanged,
    required this.selectedIntentions,
    super.onNext,
    super.onBack,
  }) : super(
          header: "What brings you to iLike?",
          subtext: "We'll use this to match you with people looking for the same things.",
          canProceed: selectedIntentions.isNotEmpty,
        );

  @override
  Widget buildContent(BuildContext context) {
    final intentions = [
      'Casual dating',
      'Looking for a relationship',
      'Just friends',
      'Start a family',
      'Not sure yet',
    ];

    return Column(
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: intentions.map((intention) {
            final isSelected = selectedIntentions.contains(intention);
            return GestureDetector(
              onTap: () {
                final newIntentions = List<String>.from(selectedIntentions);
                if (isSelected) {
                  newIntentions.remove(intention);
                } else {
                  newIntentions.add(intention);
                }
                onChanged(newIntentions);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFE91E63)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFE91E63)
                        : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  intention,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}