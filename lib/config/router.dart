import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datingapp/features/onboarding/models/onboarding_screen.dart';
import 'package:datingapp/features/signup/screens/signup_screen.dart';
import 'package:datingapp/features/signup/screens/email_signup_screen.dart';
import 'package:datingapp/features/signup/screens/email_otp_screen.dart';
import 'package:datingapp/features/signup/screens/profile_details_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/signup/email',
      builder: (context, state) => const EmailSignupScreen(),
    ),
    GoRoute(
      path: '/signup/email/otp',
      builder: (context, state) {
        final email = state.extra as String;
        return EmailOtpScreen(email: email);
      },
    ),
    GoRoute(
      path: '/signup/profile',
      builder: (context, state) {
        final email = state.extra as String;
        return ProfileDetailsScreen(email: email);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

// Placeholder screens (replace with your actual screens)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen')),
    );
  }
}
