import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Display fonts
  static TextStyle get displayLarge {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get displayMedium {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle get displaySmall {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }

  // Headline fonts
  static TextStyle get headlineLarge {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get headlineMedium {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle get headlineSmall {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  // Body fonts
  static TextStyle get bodyLarge {
    return GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle get bodyMedium {
    return GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );
  }

  static TextStyle get bodySmall {
    return GoogleFonts.lato(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    );
  }

  // Label fonts
  static TextStyle get labelLarge {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle get labelMedium {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle get labelSmall {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
    );
  }
}