import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String imageAddress;
  const CustomAppBar({super.key, required this.imageAddress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Adjust the height of the app bar as needed
      child: CustomPaint(
        painter: AppBarPainter(Theme.of(context).primaryColor),
        child: Center(
          child: Image.asset(imageAddress)
        ),
      ),
    );
  }
}

class AppBarPainter extends CustomPainter {
  final Color color;
  AppBarPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Customize the app bar color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height)
      ..quadraticBezierTo(size.width*( 2/5), size.height + 200, size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}