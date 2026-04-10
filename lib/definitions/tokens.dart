abstract class BootstrapSpacing {
  static const double unit = 4.0;

  static const double xxs = unit;        // 4
  static const double xs = 8.0;         // 8
  static const double sm = 12.0;        // 12
  static const double md = 16.0;        // 16
  static const double lg = 24.0;        // 24
  static const double xl = 32.0;        // 32
  static const double xxl = 48.0;       // 48
  static const double xxxl = 64.0;      // 64

  static const double cardPadding = 24.0;
  static const double pagePadding = 24.0;
  static const double elementGap = 8.0;
  static const double sectionGap = 16.0;
  
  static const double screenPaddingHorizontal = 24.0;
  static const double screenPaddingVertical = 24.0;
  
  static const double buttonPaddingHorizontal = 24.0;
  static const double buttonPaddingVertical = 12.0;
}

abstract class BootstrapRadii {
  static const double xs = BootstrapSpacing.unit;     // 4
  static const double s = BootstrapSpacing.unit;      // 4
  static const double sm = BootstrapSpacing.xs;       // 8
  static const double m = BootstrapSpacing.xs;        // 8
  static const double md = BootstrapSpacing.sm;       // 12
  static const double l = BootstrapSpacing.md;        // 16
  static const double lg = BootstrapSpacing.md;       // 16
  static const double xl = BootstrapSpacing.lg;       // 24
  static const double xxl = BootstrapSpacing.xl;      // 32

  static const double card = BootstrapSpacing.md;     // 16
  static const double button = BootstrapSpacing.sm;   // 12
  static const double input = BootstrapSpacing.sm;    // 12
  static const double modal = BootstrapSpacing.lg;    // 24

  // Aliases for the codebase
  static const double borderRadiusXs = xs;
  static const double borderRadiusS = s;
  static const double borderRadiusSm = sm;
  static const double borderRadiusM = m;
  static const double borderRadiusMd = md;
  static const double borderRadiusLg = lg;
  static const double borderRadiusXl = xl;
  static const double borderRadiusXxl = xxl;
  static const double borderRadiusCard = card;
  static const double borderRadiusDialog = modal;
}
