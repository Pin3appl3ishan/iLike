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
         header: "What are your\nexpectations?",
         subtext:
             "We'll use this to match you with people looking for the same things.",
         canProceed: selectedIntentions.isNotEmpty,
       );

  @override
  Widget buildContent(BuildContext context) {
    final intentions = [
      'Activity partner',
      'Casual dating',
      'Depends on our connections',
      'Friends first',
      'Start a family',
    ];

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // Top row - 3 small cards
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      // Left column - 3 stacked cards
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              child: _buildCard(
                                'Activity\npartner',
                                intentions[0],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _buildCard(
                                'Casual\ndating',
                                intentions[1],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _buildCard('Friends first', intentions[3]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Right side - large card
                      Expanded(
                        flex: 1,
                        child: _buildCard(
                          'Depends\non our\nconnections',
                          intentions[2],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Bottom row - single card
                Expanded(
                  flex: 1,
                  child: _buildCard('Start a\nfamily', intentions[4]),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCard(String displayText, String value) {
    final isSelected = selectedIntentions.contains(value);

    return GestureDetector(
      onTap: () {
        final newIntentions = List<String>.from(selectedIntentions);
        if (isSelected) {
          newIntentions.remove(value);
        } else {
          // For single selection, clear previous selections
          newIntentions.clear();
          newIntentions.add(value);
        }
        onChanged(newIntentions);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFFE91E63) // Pink fill when selected
                  : Colors.white, // White background when not selected
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                displayText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected
                          ? Colors.white
                          : Colors.black, // Black text when not selected
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
