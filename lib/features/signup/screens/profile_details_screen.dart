import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final String email;

  const ProfileDetailsScreen({super.key, required this.email});

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  static const Color goldColor = Color(0xFFEEB738);
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

  void _onSelectBirthday() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year - 18); // Must be at least 18

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: goldColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedBirthday = picked);
    }
  }

  void _onConfirm() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your first name')),
      );
      return;
    }

    if (lastName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your last name')),
      );
      return;
    }

    if (_selectedBirthday == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birthday')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Call backend to register with profile details
    // await _registerUser(
    //   email: widget.email,
    //   firstName: firstName,
    //   lastName: lastName,
    //   birthday: _selectedBirthday,
    // );

    // For now, navigate to home
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go('/home');
      }
    });
  }

  void _onSkip() {
    context.go('/home');
  }

  String _formatBirthday(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: _onSkip,
              child: const Center(
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: goldColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Heading
              const Text(
                'Profile details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 48),

              // Profile photo upload area
              GestureDetector(
                onTap: () {
                  // TODO: Implement image picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Image picker coming soon')),
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: goldColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // First name field
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First name',
                  labelStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  hintText: 'David',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.03),
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

              const SizedBox(height: 20),

              // Last name field
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last name',
                  labelStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: 14,
                  ),
                  hintText: 'Peterson',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.03),
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

              const SizedBox(height: 20),

              // Birthday selector
              GestureDetector(
                onTap: _onSelectBirthday,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: goldColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: goldColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: goldColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedBirthday != null
                            ? _formatBirthday(_selectedBirthday!)
                            : 'Choose birthday date',
                        style: TextStyle(
                          color: _selectedBirthday != null
                              ? Colors.black
                              : goldColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // Confirm button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onConfirm,
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
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
