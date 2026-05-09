import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datingapp/features/onboarding/models/onboarding_screen.dart';
import 'package:datingapp/features/signup/screens/signup_screen.dart';
import 'package:datingapp/features/signup/screens/email_signup_screen.dart';
import 'package:datingapp/features/signup/screens/email_otp_screen.dart';
import 'package:datingapp/features/signup/screens/friends_screen.dart';
import 'package:datingapp/features/home/screens/home_screen.dart';
import 'package:datingapp/features/signup/screens/i_am_screen.dart';
import 'package:datingapp/features/signup/screens/notification_screen.dart';
import 'package:datingapp/features/signup/screens/passions_screen.dart';
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
      path: '/signup/iam',
      builder: (context, state) {
        final email = state.extra as String;
        return IAmScreen(email: email);
      },
    ),
    GoRoute(
      path: '/signup/passions',
      builder: (context, state) {
        final email = state.extra as String;
        return PassionsScreen(email: email);
      },
    ),
    GoRoute(
      path: '/signup/friends',
      builder: (context, state) {
        final email = state.extra as String;
        return FriendsScreen(email: email);
      },
    ),
    GoRoute(
      path: '/signup/notifications',
      builder: (context, state) {
        final email = state.extra as String;
        return NotificationScreen(email: email);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

