import 'package:flutter/material.dart';

import '../models/chant_models.dart';
import 'chant_chrome.dart';

class MalaCounter extends StatefulWidget {
  const MalaCounter({super.key, required this.count});

  final int count;

  @override
  State<MalaCounter> createState() => _MalaCounterState();
}

class _MalaCounterState extends State<MalaCounter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void didUpdateWidget(MalaCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _pulse.forward(from: 0).whenComplete(() {
        if (mounted) _pulse.reverse();
      });
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

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
                RepaintBoundary(
                  child: Image.asset(
                    'assets/images/mala.png',
                    width: width,
                    height: height,
                    fit: BoxFit.fill,
                    filterQuality: FilterQuality.medium,
                    gaplessPlayback: true,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.24),
                  child: AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 + (_pulse.value * 0.06),
                        child: child,
                      );
                    },
                    child: Text(
                      formatCount(widget.count),
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
