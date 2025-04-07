import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _addDeviceAndNavigate();
  }

  // Method to call the API and navigate
  Future<void> _addDeviceAndNavigate() async {
    const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/device/add';
    final Map<String, dynamic> deviceData = {
      "deviceType": "android",
      "deviceId": "C6179909526098",
      "deviceName": "Samsung-MT200",
      "deviceOSVersion": "2.3.6",
      "deviceIPAddress": "11.433.445.66",
      "lat": 9.9312,
      "long": 76.2673,
      "buyer_gcmid": "",
      "buyer_pemid": "",
      "app": {
        "version": "1.20.5",
        "installTimeStamp": "2022-02-10T12:33:30.696Z",
        "uninstallTimeStamp": "2022-02-10T12:33:30.696Z",
        "downloadTimeStamp": "2022-02-10T12:33:30.696Z"
      }
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(deviceData),
      );

      if (response.statusCode == 200) {
        // Navigate to the login page if API call is successful
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Handle API failure
        _showError("Failed to add device: ${response.body}");
      }
    } catch (e) {
      _showError("Error occurred: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.png', // Replace with your asset path
              fit: BoxFit.cover,
            ),
          ),
          // Centered content
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure content is centered vertically
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
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
