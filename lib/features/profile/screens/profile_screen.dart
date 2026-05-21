import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditMode = false;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  
  // Controllers for editing
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  final Color goldColor = const Color(0xFFF2B93B);
  final Color darkTextColor = const Color(0xFF003328);
  final Color greyTextColor = const Color(0xFF656565);
  final Color backgroundColor = const Color(0xFFF7FBF9);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getProfile();
      setState(() {
        _userData = data;
        _nameController.text = data['name'] ?? '';
        _bioController.text = data['bio'] ?? '';
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    try {
      await ApiService.updateProfile({
        'name': _nameController.text,
        'bio': _bioController.text,
      });
      _fetchProfile(); // Refresh data
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeaderButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                  _HeaderButton(
                    icon: Icons.settings_outlined,
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: _isEditMode ? _buildEditMode() : _buildViewMode(),
                    ),
            ),

            // Bottom Toggle
            _buildBottomToggle(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Profile Photo with indicators
          Stack(
            children: [
              Container(
                height: 480,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    image: _userData?['avatar'] != null 
                      ? NetworkImage(_userData!['avatar'])
                      : const AssetImage('assets/images/image1.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Indicators
              Positioned(
                top: 20,
                left: 20,
                right: 20,
                child: Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: index == 0 ? goldColor : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Upload/Action button
              Positioned(
                top: 30,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_upward, color: Colors.white),
                ),
              ),
              // Name and Location Overlay
              Positioned(
                bottom: 30,
                left: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_userData?['name'] ?? 'User'}, ${_userData?['age'] ?? ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          _userData?['location'] ?? 'Add location',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_userData?['bio'] != null && _userData!['bio'].isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Me',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF003829),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _userData!['bio'],
                    style: TextStyle(color: greyTextColor, fontSize: 16),
                  ),
                ],
              ),
            ),
           const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEditMode() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Photo Grid
          Row(
            children: [
              _buildPhotoSlot('assets/images/image1.png'),
              const SizedBox(width: 12),
              _buildEmptyPhotoSlot(),
              const SizedBox(width: 12),
              _buildEmptyPhotoSlot(),
            ],
          ),
          const SizedBox(height: 24),
          
          // Name Input
          _buildTextField(_nameController, 'Name'),
          const SizedBox(height: 16),
          
          // Bio Input
          _buildTextField(
            _bioController,
            'Bio',
            maxLines: 4,
          ),
          const SizedBox(height: 24),
          
          // Location Row
          _buildInfoRow('Location', _userData?['location'] ?? 'Not set'),
          const SizedBox(height: 12),
          
          // Change Number Row
          _buildInfoRow('Change your number', _userData?['phone'] ?? ''),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPhotoSlot(String asset) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(asset),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyPhotoSlot() {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: darkTextColor.withOpacity(0.2),
            style: BorderStyle.solid, // Should be dashed if possible
          ),
        ),
        child: Icon(Icons.add, color: darkTextColor, size: 32),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: InputBorder.none,
        ),
        style: TextStyle(
          color: darkTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String trailing) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: darkTextColor,
              fontSize: 16,
            ),
          ),
          Row(
            children: [
              if (trailing.isNotEmpty)
                Text(
                  trailing,
                  style: TextStyle(
                    color: greyTextColor,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: darkTextColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleAction(
              label: 'Profile View',
              icon: Icons.remove_red_eye_outlined,
              isActive: !_isEditMode,
              onTap: () {
                if (_isEditMode) {
                  _updateProfile(); // Save when switching back to view
                }
                setState(() => _isEditMode = false);
              },
              activeColor: goldColor,
            ),
          ),
          Expanded(
            child: _ToggleAction(
              label: 'Edit Profile',
              icon: Icons.edit_outlined,
              isActive: _isEditMode,
              onTap: () => setState(() => _isEditMode = true),
              activeColor: goldColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF003328), size: 24),
      ),
    );
  }
}

class _ToggleAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const _ToggleAction({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xFF003328),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF003328),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
