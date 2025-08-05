import 'package:flutter/material.dart';
import 'package:ilike/features/profile/presentation/widgets/onboarding_step_widget.dart';

class NameStep extends OnboardingStepWidget {
  final String? initialValue;
  final Function(String) onChanged;

  NameStep({
    super.key,
    required this.onChanged,
    this.initialValue,
    super.onNext,
    super.onBack,
  }) : super(
          header: "Let's get started — what's your name?",
          subtext: "This is how people will know you in iLike.",
          canProceed: initialValue?.isNotEmpty == true,
        );

  @override
  Widget buildContent(BuildContext context) {
    return _NameStepContent(
      initialValue: initialValue,
      onChanged: onChanged,
    );
  }
}

class _NameStepContent extends StatefulWidget {
  final String? initialValue;
  final Function(String) onChanged;

  const _NameStepContent({
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<_NameStepContent> createState() => _NameStepContentState();
}

class _NameStepContentState extends State<_NameStepContent> {
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
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {}); // Update canProceed state
          },
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Your name',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
      ],
    );
  }
}
