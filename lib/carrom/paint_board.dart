import 'dart:math';

import 'package:allgames/carrom/home_main.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class CarromBoardPainter extends CustomPainter {
  final Striker striker;
  final List<Coin> coins;
  final bool isAiming;
  final double aimAngle;
  final double aimPower;
  final bool isPlayer1Turn;

  CarromBoardPainter(
    this.striker,
    this.coins,
    this.isAiming,
    this.aimAngle,
    this.aimPower,
    this.isPlayer1Turn,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw board background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.transparent, // Wooden board color
    );

    // Draw border
    paint.color = Colors.transparent!;
    paint.strokeWidth = 4;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Draw pockets with proper depth effect
    final pocketRadius = 15.0;
    final pocketPositions = [
      const Offset(0, 0),
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    for (var pocket in pocketPositions) {
      // Draw pocket shadow/depth
      final gradientPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.transparent,
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: pocket, radius: pocketRadius),
        );
      canvas.drawCircle(pocket, pocketRadius, gradientPaint);

      // Draw pocket rim
      paint.color = Colors.transparent!;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawCircle(pocket, pocketRadius, paint);

      // Draw inner pocket
      paint.color = Colors.transparent;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(pocket, pocketRadius - 2, paint);
    }

    // Draw center circle decoration
    paint.style = PaintingStyle.stroke;
    paint.color = Colors.transparent;
    final centerPoint = Offset(size.width / 2, size.height / 2);

    // Outer decorative circle
    canvas.drawCircle(centerPoint, 40, paint);

    // Inner decorative circle
    paint.strokeWidth = 1;
    canvas.drawCircle(centerPoint, 30, paint);

    // Center point
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(centerPoint, 3, paint);

    // Draw striker base line
    paint.color = Colors.transparent;
    paint.strokeWidth = 1;
    paint.style = PaintingStyle.stroke;

    double strikerLineY =
        isPlayer1Turn ? size.height * 0.85 : size.height * 0.15;
    canvas.drawLine(
      Offset(40, strikerLineY),
      Offset(size.width - 40, strikerLineY),
      paint,
    );

    // Draw aiming line when applicable
    if (isAiming) {
      // Calculate arrow length based on aim power
      final arrowLength = aimPower * 1.5; // Adjust multiplier as needed
      final endPoint = striker.position +
          Offset(cos(aimAngle) * arrowLength, sin(aimAngle) * arrowLength);
      final arrowPath = Path()
        ..moveTo(striker.position.dx, striker.position.dy)
        ..lineTo(endPoint.dx, endPoint.dy)
        ..lineTo(endPoint.dx - 10, endPoint.dy - 10)
        ..moveTo(endPoint.dx, endPoint.dy)
        ..lineTo(endPoint.dx - 10, endPoint.dy + 10);
      // Create gradient shader for the arrow
      final Shader arrowShader = RadialGradient(
        colors: [
          Colors.orange.withOpacity(0.8),
          Colors.yellow.withOpacity(0.4),
          Colors.orange
        ],
        center: Alignment.center,
        radius: 0.7,
      ).createShader(
          Rect.fromCircle(center: striker.position, radius: arrowLength));

      // Create paint with gradient and variable width
      final arrowPaint = Paint()
        ..shader = arrowShader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 // Thicker arrow base
        ..strokeCap = StrokeCap.round;
      // Draw the arrow
      canvas.drawPath(arrowPath, arrowPaint);

      // Draw a circle around the arrow
      final circlePaint = Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawCircle(striker.position, arrowLength, circlePaint);
    }

    // Draw coins with shadows and borders
    for (var coin in coins) {
      // Draw coin shadow
      final shadowPaint = Paint()
        ..color = Colors.black26
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawCircle(
        coin.position + const Offset(1, 1),
        coin.radius,
        shadowPaint,
      );

      // Draw coin border
      canvas.drawCircle(
        coin.position,
        coin.radius + 1,
        Paint()..color = Colors.black87,
      );

      // Draw coin
      canvas.drawCircle(
        coin.position,
        coin.radius,
        Paint()..color = coin.color,
      );

      // Add shine effect
      final shinePaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.5, -0.5),
          radius: 0.7,
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: coin.position, radius: coin.radius),
        );
      canvas.drawCircle(coin.position, coin.radius, shinePaint);
    }

    // Draw striker with shadow and effects
    // Striker shadow
    final strikerShadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      striker.position + const Offset(1, 1),
      striker.radius,
      strikerShadowPaint,
    );

    // Striker border
    canvas.drawCircle(
      striker.position,
      striker.radius + 1,
      Paint()..color = Colors.black87,
    );

    // Striker body
    canvas.drawCircle(
      striker.position,
      striker.radius,
      Paint()..color = Colors.white,
    );

    // Striker shine effect
    final strikerShinePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -0.5),
        radius: 0.7,
        colors: [
          Colors.white.withOpacity(0.6),
          Colors.orange.withOpacity(1),
        ],
      ).createShader(
        Rect.fromCircle(center: striker.position, radius: striker.radius),
      );
    canvas.drawCircle(striker.position, striker.radius, strikerShinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
