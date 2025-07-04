import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class GenderStep extends OnboardingStepWidget {
  final String? selectedGender;
  final Function(String) onChanged;

  const GenderStep({
    super.key,
    required this.onChanged,
    this.selectedGender,
    super.onNext,
    super.onBack,
  }) : super(
         header: "How do you identify?",
         subtext: "Choose your gender.",
         canProceed: selectedGender != null,
       );

  @override
  Widget buildContent(BuildContext context) {
    final genders = ['Male', 'Female', 'Non-binary', 'Other'];

    return Column(
      children: [
        ...genders.map(
          (gender) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => onChanged(gender),
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      selectedGender == gender
                          ? const Color(0xFFE91E63).withValues(alpha: 0.1)
                          : Colors.grey[50],
                  side: BorderSide(
                    color:
                        selectedGender == gender
                            ? const Color(0xFFE91E63)
                            : Colors.grey[300]!,
                    width: selectedGender == gender ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  gender,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        selectedGender == gender
                            ? const Color(0xFFE91E63)
                            : Colors.black,
                    fontWeight:
                        selectedGender == gender
                            ? FontWeight.w600
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
