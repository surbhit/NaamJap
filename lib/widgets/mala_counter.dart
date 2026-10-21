import 'package:flutter/material.dart';

import '../models/chant_models.dart';
import 'chant_chrome.dart';

class MalaCounter extends StatelessWidget {
  const MalaCounter({
    super.key,
    required this.count,
    this.pulse = 1,
  });

  final int count;
  final double pulse;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const aspect = 487 / 622;
        var width = constraints.maxWidth;
        var height = width / aspect;
        if (height > constraints.maxHeight && constraints.maxHeight.isFinite) {
          height = constraints.maxHeight;
          width = height * aspect;
        }
        final fontSize = (width * 0.2).clamp(46.0, 84.0);
        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/mala.png',
                  width: width,
                  height: height,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
                Align(
                  alignment: const Alignment(0, -0.24),
                  child: AnimatedScale(
                    scale: pulse,
                    duration: const Duration(milliseconds: 120),
                    curve: Curves.easeOut,
                    child: Text(
                      formatCount(count),
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: chantBrown,
                        height: 1,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
