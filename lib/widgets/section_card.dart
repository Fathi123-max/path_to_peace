import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final bool withGlassEffect;
  final List<BoxShadow>? shadows;
  final Color? backgroundColor;
  final double? borderRadius;
  final VoidCallback? onTap;

  const SectionCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.withGlassEffect = true,
    this.shadows,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    // Default glass effect colors based on theme
    final glassColor = isDarkMode 
        ? colorScheme.surface.withOpacity(0.3) 
        : Colors.white.withOpacity(0.3);
        
    // Default background color
    final bg = backgroundColor ?? 
        (withGlassEffect 
            ? colorScheme.surface.withOpacity(0.8)
            : colorScheme.surface);
            
    // Default shadows
    final shadowList = shadows ?? [DesignTokens.shadowMd];
    
    // Default border radius
    final radius = borderRadius ?? DesignTokens.radiusXl;

    final cardContent = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadowList,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: withGlassEffect
            ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Padding(
                  padding: padding ?? EdgeInsets.all(DesignTokens.spacingLg),
                  child: child,
                ),
              )
            : Padding(
                padding: padding ?? EdgeInsets.all(DesignTokens.spacingLg),
                child: child,
              ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: cardContent,
    );
  }
}