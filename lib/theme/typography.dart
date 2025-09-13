import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // Display fonts
  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  // Headline fonts
  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  // Body fonts
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.lato(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  // Label fonts
  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }
}