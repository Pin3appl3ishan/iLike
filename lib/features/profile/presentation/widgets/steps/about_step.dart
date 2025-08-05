import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class AboutStep extends OnboardingStepWidget {
  final int? age;
  final String? bio;
  final Function(int) onAgeChanged;
  final Function(String) onBioChanged;

  AboutStep({
    super.key,
    required this.onAgeChanged,
    required this.onBioChanged,
    this.age,
    this.bio,
    super.onNext,
    super.onBack,
  }) : super(
          header: "Tell us about you",
          subtext: "The more we know, the better we can match.",
          canProceed: age != null && age >= 18 && bio?.isNotEmpty == true,
        );

  @override
  Widget buildContent(BuildContext context) {
    return _AboutStepContent(
      age: age,
      bio: bio,
      onAgeChanged: onAgeChanged,
      onBioChanged: onBioChanged,
    );
  }
}

class _AboutStepContent extends StatefulWidget {
  final int? age;
  final String? bio;
  final Function(int) onAgeChanged;
  final Function(String) onBioChanged;

  const _AboutStepContent({
    required this.onAgeChanged,
    required this.onBioChanged,
    this.age,
    this.bio,
  });

  @override
  State<_AboutStepContent> createState() => _AboutStepContentState();
}

class _AboutStepContentState extends State<_AboutStepContent> {
  late TextEditingController _ageController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.age?.toString() ?? '');
    _bioController = TextEditingController(text: widget.bio ?? '');
  }

  @override
  void dispose() {
    _ageController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentAge = widget.age;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Age',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _ageController,
          onChanged: (value) {
            final ageValue = int.tryParse(value);
            if (ageValue != null) widget.onAgeChanged(ageValue);
          },
          keyboardType: TextInputType.number,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Your age (must be 18 or older)',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
            errorText: currentAge != null && currentAge < 18
                ? 'You must be at least 18 years old'
                : null,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Bio',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _bioController,
          onChanged: widget.onBioChanged,
          maxLines: 4,
          maxLength: 500,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Tell us about yourself...',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
