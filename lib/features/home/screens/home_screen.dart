import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;
  bool _isLoading = true;
  String _location = 'Chicago, IL';
  List<Map<String, dynamic>> _profiles = const [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      
      final response = await ApiService.fetchDiscoverProfiles(email: email);
      final profiles = (response['profiles'] as List<dynamic>? ?? const [])
          .cast<Map<String, dynamic>>();

      if (!mounted) {
        return;
      }

      setState(() {
        _location = response['location'] as String? ?? 'Chicago, IL';
        _profiles = profiles;
        _currentIndex = 0;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load discover profiles')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _advanceCard() {
    if (_profiles.isEmpty) {
      return;
    }

    final nextIndex = math.min(_currentIndex + 1, _profiles.length - 1);
    if (nextIndex == _currentIndex) {
      return;
    }

    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentProfile = _profiles.isNotEmpty ? _profiles[_currentIndex] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
              child: Row(
                children: [
                  const _SquareTopButton(icon: Icons.chevron_left_rounded),
                  const Spacer(),
                  Column(
                    children: [
                      const Text(
                        'Discover',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _location,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF656565),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const _SquareTopButton(icon: Icons.tune_rounded),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: goldColor))
                  : _profiles.isEmpty
                      ? _EmptyDiscover(onRefresh: _loadProfiles)
                      : Column(
                          children: [
                            SizedBox(
                              height: 610,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Positioned(
                                    top: 6,
                                    child: Container(
                                      width: 585 * 0.9,
                                      height: 510,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD9E8F4),
                                        borderRadius: BorderRadius.circular(34),
                                      ),
                                    ),
                                  ),
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: _profiles.length,
                                    onPageChanged: (index) {
                                      setState(() => _currentIndex = index);
                                    },
                                    itemBuilder: (context, index) {
                                      final profile = _profiles[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 42),
                                        child: _ProfileCard(
                                          profile: profile,
                                          activeIndex: index,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _ActionBubble(
                                    size: 84,
                                    color: Colors.white,
                                    icon: Icons.close_rounded,
                                    iconColor: const Color(0xFFFF6E21),
                                    onTap: _advanceCard,
                                  ),
                                  _ActionBubble(
                                    size: 112,
                                    color: goldColor,
                                    icon: Icons.favorite_rounded,
                                    iconColor: Colors.white,
                                    shadowColor: goldColor.withOpacity(0.32),
                                    onTap: _advanceCard,
                                  ),
                                  _ActionBubble(
                                    size: 84,
                                    color: Colors.white,
                                    icon: Icons.star_rounded,
                                    iconColor: const Color(0xFF8D26B8),
                                    onTap: _advanceCard,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareTopButton extends StatelessWidget {
  const _SquareTopButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE9E2D9), width: 1.2),
      ),
      child: Icon(icon, color: const Color(0xFFF2B93B), size: 34),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.profile,
    required this.activeIndex,
  });

  final Map<String, dynamic> profile;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final imageUrl = profile['avatar'] as String? ?? '';
    final name = profile['name'] as String? ?? 'Unknown';
    final age = profile['age']?.toString() ?? '';
    final bio = profile['bio'] as String? ?? '';
    final distanceKm = profile['distance_km']?.toString() ?? '1';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, 0.15),
                  Color.fromRGBO(0, 0, 0, 0.10),
                  Color.fromRGBO(0, 0, 0, 0.58),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Positioned(
            top: 26,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    '$distanceKm km',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 210,
            child: Container(
              width: 48,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(20),
                ),
              ),
              child: Column(
                children: List.generate(
                  5,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == activeIndex % 5
                            ? Colors.white
                            : Colors.white.withOpacity(0.55),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name${age.isNotEmpty ? ', $age' : ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  bio,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBubble extends StatelessWidget {
  const _ActionBubble({
    required this.size,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    this.shadowColor,
  });

  final double size;
  final Color color;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: (shadowColor ?? Colors.black.withOpacity(0.08)),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.42),
      ),
    );
  }
}
class _EmptyDiscover extends StatelessWidget {
  const _EmptyDiscover({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No profiles yet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          const Text(
            'Seed demo users or refresh the feed.',
            style: TextStyle(color: Color(0xFF6A6A6A)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRefresh,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}
