import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class InterestsStep extends OnboardingStepWidget {
  final List<String> selectedInterests;
  final Function(List<String>) onChanged; 

  InterestsStep({
    super.key,
    required this.onChanged,
    required this.selectedInterests,
    super.onNext,
    super.onBack,
  }) : super(
          header: "What do you love doing?",
          subtext: "This helps us connect you with like-minded people.",
          canProceed: selectedInterests.isNotEmpty,
        );

  @override
  Widget buildContent(BuildContext context) {
    final interests = [
      'Music', 'Gaming', 'Travel', 'Sports', 'Books', 'Tech',
      'Fitness', 'Cooking', 'Art', 'Photography', 'Dancing',
      'Movies', 'Hiking', 'Fashion', 'Yoga', 'Pets'
    ];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    final newInterests = List<String>.from(selectedInterests);
                    if (isSelected) {
                      newInterests.remove(interest);
                    } else {
                      newInterests.add(interest);
                    }
                    onChanged(newInterests);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE91E63)
                          : Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFE91E63)
                            : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}