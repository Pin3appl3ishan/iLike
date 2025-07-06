import 'package:flutter/material.dart';

abstract class OnboardingStepWidget extends StatelessWidget {
  final String header;
  final String subtext;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool canProceed;

  const OnboardingStepWidget({
    super.key,
    required this.header,
    required this.subtext,
    this.onNext,
    this.onBack,
    this.canProceed = true,
  });

  Widget buildContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: onBack,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                header,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtext,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: buildContent(context),
              ),
              if (onNext != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: canProceed ? onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}