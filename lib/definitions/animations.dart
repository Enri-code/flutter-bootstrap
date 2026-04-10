import 'package:flutter/animation.dart';

abstract class BootstrapDurations {
  static const int fastest = 50;
  static const int fast = 100;
  static const int normal = 200;
  static const int moderate = 300;
  static const int slow = 400;
  static const int slower = 600;
  static const int slowest = 1000;

  static const int pageTransition = 300;
  static const int dialogTransition = 200;
  static const int buttonPress = 100;
  static const int shimmer = 1500;
}

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
  static const Duration fastest = Duration(
    milliseconds: BootstrapDurations.fastest,
  );
  static const Duration fast = Duration(milliseconds: BootstrapDurations.fast);
  static const Duration normal = Duration(
    milliseconds: BootstrapDurations.normal,
  );
  static const Duration moderate = Duration(
    milliseconds: BootstrapDurations.moderate,
  );
  static const Duration slow = Duration(milliseconds: BootstrapDurations.slow);
  static const Duration slower = Duration(
    milliseconds: BootstrapDurations.slower,
  );
  static const Duration slowest = Duration(
    milliseconds: BootstrapDurations.slowest,
  );

  // Semantic durations
  static const Duration pageTransition = Duration(
    milliseconds: BootstrapDurations.pageTransition,
  );
  static const Duration dialogTransition = Duration(
    milliseconds: BootstrapDurations.dialogTransition,
  );
  static const Duration buttonPress = Duration(
    milliseconds: BootstrapDurations.buttonPress,
  );
  static const Duration shimmer = Duration(
    milliseconds: BootstrapDurations.shimmer,
  );
}
