import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [_buildBgImage(), _buildBgGradient(context), Modal()],
          ),
        ),
      ),
    );
  }

  Widget _buildBgImage() {
    return Positioned.fill(
      child: Image.asset('assets/images/image_bg.png', fit: BoxFit.cover),
    );
  }

  Widget _buildBgGradient(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: 293,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: 293,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 0,
            right: 0,
            child: Container(
              width: size.width / 2,
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            child: Container(
              width: size.width / 2,
              height: size.height,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.transparent, Colors.black],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Modal extends StatelessWidget {
  const Modal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 150,
          margin: EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: Colors.blue.withValues(alpha: 0.5),
            shape: SmoothRectangleBorder(
              side: BorderSide(color: Colors.white, width: 1),
              borderRadius: SmoothBorderRadius(
                cornerRadius: 30,
                cornerSmoothing: 1,
              ),
            ),
          ),
        ),
        CustomPaint(
          painter: SquircleBorderPainter(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.attach_money, color: Colors.green, size: 28),
                const SizedBox(width: 8),
                Text(
                  "1 990 000 ₽",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SquircleBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final shape = SmoothRectangleBorder(
      borderRadius: SmoothBorderRadius(cornerRadius: 20, cornerSmoothing: 1),
    );

    final path = shape.getOuterPath(rect);

    final gradient = LinearGradient(
      colors: [
        Colors.white.withValues(alpha: 0.5),
        Colors.white.withValues(alpha: 0.2),
      ],
      stops: [0.0, 0.5],
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
