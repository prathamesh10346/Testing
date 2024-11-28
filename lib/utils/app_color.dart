import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFEA932D);
  static const Color secondaryColor = Color(0xFFEA932D);
  static const Color buttonColor = Color(0xFFEA932D);
  static const Color lightButtonColor = Color(0xFF6D5A2B);
  static const Color redButtonColor = Color(0xFFA20907);
  static const Color lightWhiteColor = Color(0xFFE0E0E0);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color blue = Colors.blue;

  static RadialGradient get radialGradient {
    return RadialGradient(
      colors: [
        primaryColor,
        secondaryColor,
      ],
      stops: [0.0, 0.5],
      center: Alignment.bottomCenter,
      radius: 1.5,
    );
  }
}

class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEA932D), Color(0xFFEA932D)],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GradientBorderOTPPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));

    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF6D5A2B), Color(0xFF6D5A2B)],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
