import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.3.9:8000/api'; // Update with your backend URL

  static Future<Map<String, dynamic>> fetchDiscoverProfiles({
    String? email,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/discover').replace(
        queryParameters: email == null ? null : {'email': email},
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception('Failed to load discover profiles');
    } catch (e) {
      throw Exception('Error loading discover profiles: $e');
    }
  }

  // Send OTP to email
  static Future<Map<String, dynamic>> sendEmailOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/email/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending OTP: $e');
    }
  }

  // Verify email OTP
  static Future<Map<String, dynamic>> verifyEmailOtp(
      String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/email/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      throw Exception('Error verifying OTP: $e');
    }
  }

  static Future<Map<String, dynamic>> completeEmailSignup({
    required String email,
    required String firstName,
    required String lastName,
    required DateTime birthday,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/email/complete-signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'dob': birthday.toIso8601String().split('T').first,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to complete signup');
      }
    } catch (e) {
      throw Exception('Error completing signup: $e');
    }
  }

  static Future<Map<String, dynamic>> saveGender({
    required String email,
    required String gender,
    String? customGender,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/onboarding/gender'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'gender': gender,
          if (customGender != null && customGender.isNotEmpty)
            'custom_gender': customGender,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to save gender');
    } catch (e) {
      throw Exception('Error saving gender: $e');
    }
  }

  static Future<Map<String, dynamic>> saveInterests({
    required String email,
    required List<String> interests,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/onboarding/interests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'interests': interests,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to save interests');
    } catch (e) {
      throw Exception('Error saving interests: $e');
    }
  }

  static Future<Map<String, dynamic>> saveFriendsPermission({
    required String email,
    required bool enabled,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/onboarding/friends'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'find_friends_enabled': enabled,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to save friends preference');
    } catch (e) {
      throw Exception('Error saving friends preference: $e');
    }
  }

  static Future<Map<String, dynamic>> saveNotificationPreference({
    required String email,
    required bool enabled,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/onboarding/notifications'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'notifications_enabled': enabled,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to save notification preference');
    } catch (e) {
      throw Exception('Error saving notification preference: $e');
    }
  }

  // Register user with email and password
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to register');
      }
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  // Login with email and password
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['message'] ?? 'Failed to login');
      }
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }
}
