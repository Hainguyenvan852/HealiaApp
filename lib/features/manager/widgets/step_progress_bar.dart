import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final EdgeInsetsGeometry padding;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
              decoration: BoxDecoration(
                color: isCompleted ? const Color(0xFF6246EA) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}