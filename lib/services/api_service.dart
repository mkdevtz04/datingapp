import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api'; // Update with your backend URL

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
