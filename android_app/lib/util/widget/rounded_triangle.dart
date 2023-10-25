import 'package:flutter/material.dart';

class RoundedTriangle extends StatelessWidget {
  const RoundedTriangle({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ShapesPainter(color),
      child: Container(
        height: 40,
        width: 40,
      ),
    );
  }
}

class _ShapesPainter extends CustomPainter {
  final Color color;

  _ShapesPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var path = Path();
    path.lineTo(0, 0);
    path.cubicTo(size.width + 8, 0, size.width, size.height - 47, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
