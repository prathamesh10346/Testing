import 'package:allgames/home/home_screen.dart';
import 'package:allgames/providers/auth/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildLoginButton(context),
      backgroundColor: const Color(0xFF1D1226),
      body: SafeArea(
        child: Column(
          children: [
            // Curved Profile Container
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF24202E),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'App Name',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.purple[200],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              child: Consumer<LoginProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          if (!provider.isOtpScreen) ...[
                            _buildEmailInput(context, provider),
                          ] else ...[
                            _buildOtpInput(context, provider),
                          ],
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInput(BuildContext context, LoginProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email id or Mobile number',
          style: TextStyle(
            color: Color(0xff827B7B),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 50,
          child: TextField(
            onChanged: provider.setEmail,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Email address',
              hintStyle: TextStyle(color: Color(0xffCDCCCC), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFF3F375E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'OTP will be sent to this email id',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInput(BuildContext context, LoginProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTP',
          style: TextStyle(
            color: Color(0xff827B7B),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            6,
            (index) => SizedBox(
              width: 45,
              height: 45,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  counterText: "",
                  filled: true,
                  fillColor: const Color(0xFF3F375E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resend',
              style: TextStyle(
                color: Color(0xff827B7B),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '04:59',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginButton(
    BuildContext context,
  ) {
    return Consumer<LoginProvider>(builder: (context, provider, child) {
      return Container(
        height: 110,
        color: Colors.transparent,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF24202E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              child: Container(
                width: double.infinity,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFF3F3660),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {
                    if (!provider.isOtpScreen) {
                      if (provider.email.isNotEmpty) {
                        provider.showOtpScreen();
                      }
                    } else {
                      // Validate OTP and proceed
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
