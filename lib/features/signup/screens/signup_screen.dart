import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static const Color goldColor = Color(0xFFEEB738);

  void _onContinueWithEmail() {
    // Navigate to email sign-up screen
    context.push('/signup/email');
  }

  void _onUsePhoneNumber() {
    // Navigate to phone sign-up screen
    context.go('/signup/phone');
  }

  void _onFacebookLogin() {
    // TODO: Implement Facebook login
  }

  void _onGoogleLogin() {
    // TODO: Implement Google login
  }

  void _onAppleLogin() {
    // TODO: Implement Apple login
  }

  void _onTermsOfUse() {
    // TODO: Navigate to terms of use
  }

  void _onPrivacyPolicy() {
    // TODO: Navigate to privacy policy
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo
              SizedBox(
                width: 80,
                height: 80,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: goldColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite,
                          size: 40,
                          color: goldColor,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 48),

              // Heading
              const Text(
                'Sign up to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 48),

              // Continue with email button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _onContinueWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Continue with email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Use phone number button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: _onUsePhoneNumber,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: const Text(
                    'Use phone number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: goldColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Divider with text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withOpacity(0.3),
                      height: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or sign up with',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withOpacity(0.3),
                      height: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Social login buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Facebook
                  _SocialLoginButton(
                    icon: Icons.facebook,
                    onPressed: _onFacebookLogin,
                  ),
                  const SizedBox(width: 24),

                  // Google
                  _SocialLoginButton(
                    icon: Icons.g_mobiledata,
                    onPressed: _onGoogleLogin,
                  ),
                  const SizedBox(width: 24),

                  // Apple
                  _SocialLoginButton(
                    icon: Icons.apple,
                    onPressed: _onAppleLogin,
                  ),
                ],
              ),

              const SizedBox(height: 60),

              // Terms and Privacy
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _onTermsOfUse,
                    child: Text(
                      'Terms of use',
                      style: const TextStyle(
                        color: goldColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    ' · ',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.3),
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: _onPrivacyPolicy,
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        color: goldColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social Login Button Widget ──
class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: const Color(0xFFEEB738),
          ),
        ),
      ),
    );
  }
}
