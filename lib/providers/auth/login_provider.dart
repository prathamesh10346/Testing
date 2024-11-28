// Add this to your login_provider.dart if not already present
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  bool _isOtpScreen = false;
  String _email = '';
  final List<String> _otp = List.filled(6, '');

  bool get isOtpScreen => _isOtpScreen;
  String get email => _email;
  List<String> get otp => _otp;

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setOtp(int index, String value) {
    if (index >= 0 && index < 6) {
      _otp[index] = value;
      notifyListeners();
    }
  }

  void showOtpScreen() {
    _isOtpScreen = true;
    notifyListeners();
  }

  void showEmailScreen() {
    _isOtpScreen = false;
    notifyListeners();
  }
}
