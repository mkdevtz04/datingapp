import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_service.dart';

class PassionsScreen extends StatefulWidget {
  final String email;

  const PassionsScreen({super.key, required this.email});

  @override
  State<PassionsScreen> createState() => _PassionsScreenState();
}

class _PassionsScreenState extends State<PassionsScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  static const Color borderColor = Color(0xFFE8E1D7);

  static const List<_InterestOption> _interestOptions = [
    _InterestOption('Photography', Icons.photo_camera_outlined),
    _InterestOption('Shopping', Icons.shopping_bag_outlined),
    _InterestOption('Karaoke', Icons.mic_none_rounded),
    _InterestOption('Yoga', Icons.self_improvement_outlined),
    _InterestOption('Cooking', Icons.ramen_dining_outlined),
    _InterestOption('Tennis', Icons.sports_tennis_outlined),
    _InterestOption('Run', Icons.directions_run_rounded),
    _InterestOption('Swimming', Icons.waves_rounded),
    _InterestOption('Art', Icons.palette_outlined),
    _InterestOption('Traveling', Icons.landscape_outlined),
    _InterestOption('Extreme', Icons.paragliding_outlined),
    _InterestOption('Music', Icons.music_note_outlined),
    _InterestOption('Drink', Icons.wine_bar_outlined),
    _InterestOption('Video games', Icons.sports_esports_outlined),
  ];

  final Set<String> _selectedInterests = {'Shopping', 'Run', 'Traveling'};
  bool _isLoading = false;

  Future<void> _continue() async {
    if (_selectedInterests.isEmpty) {
      _showMessage('Select at least one interest');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.saveInterests(
        email: widget.email,
        interests: _selectedInterests.toList(),
      );

      if (!mounted) {
        return;
      }

      context.go('/signup/friends', extra: widget.email);
    } catch (e) {
      if (!mounted) {
        return;
      }
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _SquareIconButton(onTap: () => context.pop()),
                  const Spacer(),
                  TextButton(
                    onPressed: () => context.go('/signup/friends', extra: widget.email),
                    style: TextButton.styleFrom(
                      foregroundColor: goldColor,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              const Text(
                'Your interests',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Select a few of your interests and let everyone\nknow what you\'re passionate about.',
                style: TextStyle(
                  fontSize: 17,
                  color: Color(0xFF686868),
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: GridView.builder(
                  itemCount: _interestOptions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.08,
                  ),
                  itemBuilder: (context, index) {
                    final option = _interestOptions[index];
                    final selected = _selectedInterests.contains(option.label);
                    return _InterestChip(
                      label: option.label,
                      icon: option.icon,
                      selected: selected,
                      onTap: () => _toggleInterest(option.label),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _continue,
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
                          'Continue',
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

class _InterestOption {
  const _InterestOption(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _InterestChip extends StatelessWidget {
  const _InterestChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const Color goldColor = Color(0xFFF2B93B);
  static const Color borderColor = Color(0xFFE8E1D7);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? goldColor : Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? goldColor : borderColor,
              width: 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: goldColor.withOpacity(0.28),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: selected ? Colors.white : goldColor, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE8E1D7), width: 1.2),
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFFF2B93B),
            size: 36,
          ),
        ),
      ),
    );
  }
}
