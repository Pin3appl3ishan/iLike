import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class HeightStep extends OnboardingStepWidget {
  final String? selectedHeight;
  final Function(String) onChanged;

  const HeightStep({
    super.key,
    required this.onChanged,
    this.selectedHeight,
    super.onNext,
    super.onBack,
  }) : super(
         header: "Your height?",
         subtext: "Some users love to know!",
         canProceed: selectedHeight != null,
       );

  @override
  Widget buildContent(BuildContext context) {
    final heights = [
      "Under 5'0\"",
      "5'0\"",
      "5'1\"",
      "5'2\"",
      "5'3\"",
      "5'4\"",
      "5'5\"",
      "5'6\"",
      "5'7\"",
      "5'8\"",
      "5'9\"",
      "5'10\"",
      "5'11\"",
      "6'0\"",
      "6'1\"",
      "6'2\"",
      "6'3\"",
      "6'4\"",
      "6'5\"",
      "6'6\"",
      "Over 6'6\"",
    ];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: heights.length,
            itemBuilder: (context, index) {
              final height = heights[index];
              final isSelected = selectedHeight == height;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => onChanged(height),
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isSelected
                              ? const Color(0xFFE91E63).withOpacity(0.1)
                              : Colors.grey[50],
                      side: BorderSide(
                        color:
                            isSelected
                                ? const Color(0xFFE91E63)
                                : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      height,
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            isSelected ? const Color(0xFFE91E63) : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
