import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_service.dart';

class FriendsScreen extends StatefulWidget {
  final String email;

  const FriendsScreen({super.key, required this.email});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  bool _isLoading = false;

  Future<void> _saveAndContinue(bool enabled) async {
    setState(() => _isLoading = true);

    try {
      await ApiService.saveFriendsPermission(
        email: widget.email,
        enabled: enabled,
      );

      if (!mounted) {
        return;
      }

      context.go('/signup/notifications', extra: widget.email);
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
                  onPressed: _isLoading
                      ? null
                      : () => _saveAndContinue(false),
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
              const SizedBox(height: 70),
              const _FriendArt(),
              const SizedBox(height: 90),
              const Text(
                'Search friend\'s',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'You can find friends from your contact lists\nto connected',
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
                  onPressed: _isLoading ? null : () => _saveAndContinue(true),
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
                          'Access to a contact list',
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

class _FriendArt extends StatelessWidget {
  const _FriendArt();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 320,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 45,
            child: _GlowShape.circle(
              size: 150,
              colors: const [Color(0xFFC65DDA), Color(0xFF9B32B8)],
            ),
          ),
          Positioned(
            top: 62,
            left: 35,
            child: _GlowShape.circle(
              size: 170,
              colors: const [Color(0xFFF2EAF6), Color(0xFFA632B6)],
            ),
          ),
          Positioned(
            bottom: 18,
            right: 20,
            child: _GlowShape.oval(
              width: 184,
              height: 92,
              colors: const [Color(0xFFD16CE0), Color(0xFF9B32B8)],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 12,
            child: _GlowShape.oval(
              width: 178,
              height: 88,
              colors: const [Color(0xFFF2EAF6), Color(0xFFC55BD9)],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowShape extends StatelessWidget {
  const _GlowShape.circle({
    required double size,
    required this.colors,
  })  : width = size,
        height = size,
        radius = size / 2;

  const _GlowShape.oval({
    required this.width,
    required this.height,
    required this.colors,
  }) : radius = 999;

  final double width;
  final double height;
  final double radius;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.last.withOpacity(0.24),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
    );
  }
}
