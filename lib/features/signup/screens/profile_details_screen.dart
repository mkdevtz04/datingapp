import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'birthday_picker_screen.dart';
import '../../../services/api_service.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String email;

  const ProfileDetailsScreen({super.key, required this.email});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  static const Color goldColor = Color(0xFFF2B93B);
  static const Color softGold = Color(0xFFFBF3E2);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedBirthday;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _openBirthdayPicker() async {
    final selectedDate = await Navigator.of(context).push<DateTime>(
      MaterialPageRoute(
        builder: (_) => BirthdayPickerScreen(
          initialDate: _selectedBirthday,
        ),
      ),
    );

    if (selectedDate != null) {
      setState(() => _selectedBirthday = selectedDate);
    }
  }

  Future<void> _onConfirm() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty) {
      _showMessage('Please enter your first name');
      return;
    }

    if (lastName.isEmpty) {
      _showMessage('Please enter your last name');
      return;
    }

    if (_selectedBirthday == null) {
      _showMessage('Please choose your birthday date');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.completeEmailSignup(
        email: widget.email,
        firstName: firstName,
        lastName: lastName,
        birthday: _selectedBirthday!,
      );

      if (!mounted) {
        return;
      }

      context.go('/home');
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

  void _onSkip() {
    context.go('/home');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _birthdayLabel() {
    final birthday = _selectedBirthday;
    if (birthday == null) {
      return 'Choose birthday date';
    }

    const monthNames = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${birthday.day} ${monthNames[birthday.month - 1]} ${birthday.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: goldColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Profile details',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 52),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(34),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFE7E7E7),
                                Color(0xFFD8D8D8),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 92,
                            color: Color(0xFF9D9D9D),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -8,
                      bottom: -6,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: goldColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 5),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _showMessage('Profile photo upload comes next');
                          },
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 54),
              _ProfileField(
                label: 'First name',
                controller: _firstNameController,
                hintText: 'David',
              ),
              const SizedBox(height: 20),
              _ProfileField(
                label: 'Last name',
                controller: _lastNameController,
                hintText: 'Peterson',
              ),
              const SizedBox(height: 28),
              InkWell(
                onTap: _openBirthdayPicker,
                borderRadius: BorderRadius.circular(24),
                child: Ink(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: softGold,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: goldColor.withOpacity(0.65),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.calendar_month_outlined,
                          color: goldColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          _birthdayLabel(),
                          style: TextStyle(
                            color: _selectedBirthday == null
                                ? goldColor
                                : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 150),
              SizedBox(
                width: double.infinity,
                height: 72,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: goldColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    disabledBackgroundColor: goldColor.withOpacity(0.55),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
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

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.controller,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  static const Color borderColor = Color(0xFFE7E2D8);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: Color(0xFFBEB8AE),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: borderColor, width: 1.3),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(
            color: _ProfileDetailsScreenState.goldColor,
            width: 1.8,
          ),
        ),
      ),
    );
  }
}
