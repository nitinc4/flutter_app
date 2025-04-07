import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://devapiv4.dealsdray.com/api/v2";

  // Splash Screen API
  static Future<dynamic> addDevice(Map<String, dynamic> deviceData) async {
    final url = Uri.parse("$baseUrl/user/device/add");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(deviceData),
    );
    return _processResponse(response);
  }

  // Login Screen API (Send OTP)
  static Future<dynamic> sendOtp(Map<String, dynamic> otpData) async {
    final url = Uri.parse("$baseUrl/user/otp");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(otpData),
    );
    return _processResponse(response);
  }

  // OTP Verification API
  static Future<dynamic> verifyOtp(Map<String, dynamic> otpData) async {
    final url = Uri.parse("$baseUrl/user/otp/verification");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(otpData),
    );
    return _processResponse(response);
  }

  // Register Screen API
  static Future<dynamic> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse("$baseUrl/user/email/referral");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    return _processResponse(response);
  }

  // Home Screen API (Fetch Products)
  static Future<dynamic> fetchProducts() async {
    final url = Uri.parse("$baseUrl/user/home/withoutPrice");
    final response = await http.get(url);
    return _processResponse(response);
  }

  // Helper method to process API response
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data: ${response.body}");
    }
  }
}
