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
    return _LocationStepContent(
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}

class _LocationStepContent extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const _LocationStepContent({
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<_LocationStepContent> createState() => _LocationStepContentState();
}

class _LocationStepContentState extends State<_LocationStepContent> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
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
