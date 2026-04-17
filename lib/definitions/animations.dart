import 'package:flutter/animation.dart';

abstract class BootstrapAnimations {
  // Standard Curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve linear = Curves.linear;

  // Custom Smooth Curves
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve smoothFast = Curves.easeOutCubic;
  static const Curve smoothSlow = Curves.easeInCubic;

  // Bouncy curves
  static const Curve bounce = Curves.elasticOut;
  static const Curve bounceSoft = Curves.easeOutBack;

  // Sharp curves
  static const Curve sharp = Curves.easeOutExpo;
  static const Curve sharpIn = Curves.easeInExpo;

  // Emphasized curves (Material 3 inspired)
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1);
  static const Curve emphasizedAccelerate = Cubic(0.3, 0, 0.8, 0.15);

  // Durations
  static const Duration instant = Duration.zero;
  static const Duration fastest = Duration(milliseconds: 50);
  static const Duration fast = Duration(milliseconds: 100);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration moderate = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 400);
  static const Duration slower = Duration(milliseconds: 600);
  static const Duration slowest = Duration(milliseconds: 1000);
}
