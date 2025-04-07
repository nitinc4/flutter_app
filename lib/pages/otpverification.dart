import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({required this.phoneNumber, super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  late Timer _timer;
  int _timeRemaining = 120; // 2 minutes
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        setState(() {
          _canResendOtp = true;
          _timer.cancel();
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _verifyOtp() async {
    const String apiUrl =
        'http://devapiv4.dealsdray.com/api/v2/user/otp/verification';
    final String otp =
        "${_otpController1.text}${_otpController2.text}${_otpController3.text}${_otpController4.text}";

    if (otp.isEmpty || otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP.")),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      "otp": otp,
      "deviceId": "66863b1b5120b12d7e1820ee", // Replace with a valid deviceId
      "userId": "6799f21aac0f95f80dc35e36", // Replace with a valid userId
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final bool userExists = responseData['isExistingUser'] ?? false;

        if (userExists) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/onboarding');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to verify OTP: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }

  Future<void> _resendOtp() async {
    const String apiUrl = 'http://devapiv4.dealsdray.com/api/v2/user/otp';
    final Map<String, dynamic> requestData = {
      "mobileNumber": widget.phoneNumber,
      "deviceId": "62b341aeb0ab5ebe28a758a3" // Replace with valid deviceId
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP resent successfully!")),
        );
        setState(() {
          _timeRemaining = 120;
          _canResendOtp = false;
          _startTimer();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to resend OTP: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/sms.png', // Replace with your asset path
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              "We have sent a unique OTP number to your mobile",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 20),
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOtpField(_otpController1, _focusNode1, _focusNode2),
                _buildOtpField(_otpController2, _focusNode2, _focusNode3),
                _buildOtpField(_otpController3, _focusNode3, _focusNode4),
                _buildOtpField(_otpController4, _focusNode4, null),
              ],
            ),
            const SizedBox(height: 20),
            // Timer and Resend Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _timeRemaining > 0
                      ? "Resend in ${_formatTime(_timeRemaining)}"
                      : "You can resend now",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextButton(
                  onPressed: _canResendOtp ? _resendOtp : null,
                  child: const Text(
                    "Send Again",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Verify Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "VERIFY",
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpField(TextEditingController controller, FocusNode currentFocus,
      FocusNode? nextFocus) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            currentFocus.unfocus();
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            }
          }
        },
      ),
    );
  }
}
