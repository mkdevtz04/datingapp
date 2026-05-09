import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:datingapp/services/api_service.dart';

class EmailSignupScreen extends StatefulWidget {
  const EmailSignupScreen({super.key});

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  static const Color goldColor = Color(0xFFEEB738);
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call backend to send OTP to email
      await ApiService.sendEmailOtp(email);
      
      if (mounted) {
        context.push('/signup/email/otp', extra: email);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),

              // Heading
              const Text(
                'My email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'We will send you a verification code to confirm your email address.',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // Email input field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.4),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: goldColor,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: goldColor.withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
