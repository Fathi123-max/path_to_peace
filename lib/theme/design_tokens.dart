import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DesignTokens {
  // Spacing
  static double spacingXxs = 4.r;
  static double spacingXs = 8.r;
  static double spacingSm = 12.r;
  static double spacingMd = 16.r;
  static double spacingLg = 24.r;
  static double spacingXl = 32.r;
  static double spacingXxl = 48.r;

  // Border radius
  static double radiusXs = 4.r;
  static double radiusSm = 8.r;
  static double radiusMd = 12.r;
  static double radiusLg = 16.r;
  static double radiusXl = 24.r;
  static double radiusXxl = 32.r;

  // Shadows
  static BoxShadow shadowSm = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 4.r,
    offset: Offset(0, 2.r),
  );

  static BoxShadow shadowMd = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8.r,
    offset: Offset(0, 4.r),
  );

  static BoxShadow shadowLg = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 16.r,
    offset: Offset(0, 8.r),
  );

  // Icon sizes
  static double iconXs = 16.r;
  static double iconSm = 20.r;
  static double iconMd = 24.r;
  static double iconLg = 32.r;
  static double iconXl = 40.r;

  // Button sizes
  static double buttonHeight = 44.r;
  static double buttonMinWidth = 44.r;
}