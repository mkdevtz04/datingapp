import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../services/api_service.dart';

class IAmScreen extends StatefulWidget {
  final String email;

  const IAmScreen({super.key, required this.email});

  @override
  State<IAmScreen> createState() => _IAmScreenState();
}

class _IAmScreenState extends State<IAmScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  static const Color borderColor = Color(0xFFE8E1D7);

  String? _selectedGender = 'man';
  final TextEditingController _customGenderController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _customGenderController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final selectedGender = _selectedGender;
    if (selectedGender == null) {
      _showMessage('Please choose an option');
      return;
    }

    if (selectedGender == 'other' &&
        _customGenderController.text.trim().isEmpty) {
      _showMessage('Please type your gender');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.saveGender(
        email: widget.email,
        gender: selectedGender,
        customGender: _customGenderController.text.trim(),
      );

      if (!mounted) {
        return;
      }

      context.go('/signup/passions', extra: widget.email);
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOther = _selectedGender == 'other';

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
                    onPressed: () => context.go('/signup/passions', extra: widget.email),
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
              const SizedBox(height: 40),
              const Text(
                'I am a',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 56),
              _ChoiceTile(
                label: 'Woman',
                selected: _selectedGender == 'woman',
                onTap: () => setState(() => _selectedGender = 'woman'),
              ),
              const SizedBox(height: 16),
              _ChoiceTile(
                label: 'Man',
                selected: _selectedGender == 'man',
                onTap: () => setState(() => _selectedGender = 'man'),
              ),
              const SizedBox(height: 16),
              _ChoiceTile(
                label: 'Choose another',
                selected: isOther,
                trailing: isOther ? Icons.check_rounded : Icons.chevron_right_rounded,
                onTap: () => setState(() => _selectedGender = 'other'),
              ),
              if (isOther) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _customGenderController,
                  decoration: InputDecoration(
                    hintText: 'Type your gender',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBDB6AA),
                      fontSize: 18,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 22,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: borderColor, width: 1.3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: goldColor, width: 1.8),
                    ),
                  ),
                ),
              ],
              const Spacer(),
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

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? trailing;

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
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? goldColor : borderColor,
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                trailing ?? Icons.check_rounded,
                color: selected ? Colors.white : const Color(0xFFB8B8C2),
                size: 30,
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
