import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_service.dart';

class NotificationScreen extends StatefulWidget {
  final String email;

  const NotificationScreen({super.key, required this.email});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  bool _isLoading = false;

  Future<void> _finish(bool enabled) async {
    setState(() => _isLoading = true);

    try {
      await ApiService.saveNotificationPreference(
        email: widget.email,
        enabled: enabled,
      );

      if (!mounted) {
        return;
      }

      context.go('/home');
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _isLoading ? null : () => _finish(false),
                  style: TextButton.styleFrom(
                    foregroundColor: goldColor,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: 64),
              const _NotificationArt(),
              const SizedBox(height: 90),
              const Text(
                'Enable notification\'s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Get push-notification when you get the match\nor receive a message.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF686868),
                  height: 1.7,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _finish(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'I want to be notified',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
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

class _NotificationArt extends StatelessWidget {
  const _NotificationArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 40,
            top: 30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFC56F), Color(0xFFFF8B2F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA447).withOpacity(0.28),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 36,
            top: 66,
            child: Container(
              width: 168,
              height: 146,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF5EE), Color(0xFFFF9D49)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA447).withOpacity(0.24),
                    blurRadius: 28,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 82,
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
