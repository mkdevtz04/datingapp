import 'package:flutter/material.dart';

class OnboardingItem {
  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final String buttonLabel;

  const OnboardingItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.buttonLabel,
  });
}