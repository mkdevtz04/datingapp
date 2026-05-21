import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  bool _lookProfile = false;
  bool _darkMode = false;

  // Discovery Preferences
  double _distance = 50.0;
  RangeValues _ageRange = const RangeValues(18, 35);
  String _showMe = 'everyone';

  final Color goldColor = const Color(0xFFF2B93B);
  final Color darkTextColor = const Color(0xFF003328);
  final Color backgroundColor = const Color(0xFFF7FBF9);

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.getProfile();
      setState(() {
        _userData = data;
        _lookProfile = data['profile_complete'] ?? false;
        
        final filters = data['filter_preferences'] as Map<String, dynamic>? ?? {};
        _distance = (filters['max_distance'] ?? 50).toDouble();
        _ageRange = RangeValues(
          (filters['min_age'] ?? 18).toDouble(),
          (filters['max_age'] ?? 35).toDouble(),
        );
        _showMe = filters['interested_in'] ?? 'everyone';
      });
    } catch (e) {
      debugPrint('Error fetching preferences: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePreferences() async {
    try {
      await ApiService.updateProfile({
        'filter_preferences': {
          'max_distance': _distance.toInt(),
          'min_age': _ageRange.start.toInt(),
          'max_age': _ageRange.end.toInt(),
          'interested_in': _showMe,
        },
      });
    } catch (e) {
      debugPrint('Error saving preferences: $e');
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
                children: [
                  _HeaderButton(
                    icon: Icons.arrow_back,
                    onTap: () => context.pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003328),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing the back button
                ],
              ),
            ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        const SizedBox(height: 16),

                        // Discovery Settings
                        _buildSectionTitle('Discovery Settings'),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            children: [
                              _buildSliderTile(
                                title: 'Distance',
                                value: '${_distance.toInt()} km',
                                child: Slider(
                                  value: _distance,
                                  min: 1,
                                  max: 100,
                                  activeColor: goldColor,
                                  onChanged: (val) {
                                    setState(() => _distance = val);
                                    _savePreferences();
                                  },
                                ),
                              ),
                              _buildDivider(),
                              _buildSliderTile(
                                title: 'Age Range',
                                value: '${_ageRange.start.toInt()} - ${_ageRange.end.toInt()}',
                                child: RangeSlider(
                                  values: _ageRange,
                                  min: 18,
                                  max: 100,
                                  activeColor: goldColor,
                                  onChanged: (val) {
                                    setState(() => _ageRange = val);
                                    _savePreferences();
                                  },
                                ),
                              ),
                              _buildDivider(),
                              _buildNavTile(
                                icon: Icons.people_outline,
                                title: 'Show Me',
                                value: _showMe[0].toUpperCase() + _showMe.substring(1),
                                onTap: _showGenderPreferenceDialog,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        _buildSectionTitle('App Settings'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildSwitchTile(
                          icon: Icons.vpn_key_outlined,
                          title: 'Look Your Profile',
                          value: _lookProfile,
                          onChanged: (val) => setState(() => _lookProfile = val),
                        ),
                        _buildDivider(),
                        _buildNavTile(
                          icon: Icons.person_outline,
                          title: 'Change Personality Type',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildNavTile(
                          icon: Icons.translate,
                          title: 'Language',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildNavTile(
                          icon: Icons.block_flipped,
                          title: 'Blocked List',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildSwitchTile(
                          icon: Icons.nightlight_outlined,
                          title: 'Dark Mode',
                          value: _darkMode,
                          onChanged: (val) => setState(() => _darkMode = val),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Support Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        _buildNavTile(
                          icon: Icons.mail_outline,
                          title: 'Contact Us',
                          onTap: () {},
                        ),
                        _buildDivider(),
                        _buildNavTile(
                          icon: Icons.star_outline,
                          title: 'Rate Us',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout Section
                  GestureDetector(
                    onTap: () {
                      // Handle logout
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: Color(0xFFFF2D55), size: 24),
                          const SizedBox(width: 12),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              color: Color(0xFFFF2D55),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: darkTextColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: darkTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFFE0E0E0),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE0E0E0),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: darkTextColor.withOpacity(0.5),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSliderTile({required String title, required String value, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: goldColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  void _showGenderPreferenceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Show Me',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildGenderOption('men'),
              _buildGenderOption('women'),
              _buildGenderOption('everyone'),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderOption(String option) {
    final isSelected = _showMe == option;
    return ListTile(
      title: Text(
        option[0].toUpperCase() + option.substring(1),
        style: TextStyle(
          color: isSelected ? goldColor : darkTextColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: goldColor) : null,
      onTap: () {
        setState(() => _showMe = option);
        _savePreferences();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Icon(icon, color: darkTextColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: darkTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null)
              Text(
                value,
                style: TextStyle(color: goldColor, fontWeight: FontWeight.bold),
              ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: darkTextColor, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: backgroundColor,
      indent: 60,
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
