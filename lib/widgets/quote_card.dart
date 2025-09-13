import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animations/animations.dart';
import '../models/quote.dart';
import '../widgets/share_modal.dart';
import '../theme/colors.dart';
import '../theme/design_tokens.dart';

class QuoteCard extends StatefulWidget {
  final Quote quote;

  const QuoteCard({super.key, required this.quote});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 375.w, // max-w-md from Tailwind
        ),
        child: GestureDetector(
          onTapDown: (_) => _controller.forward(),
          onTapUp: (_) => _controller.reverse(),
          onTapCancel: () => _controller.reverse(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: 500.h, // h-[500px] from CSS
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.glassLight, // rgba(255, 255, 255, 0.3) from CSS
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl), // rounded-2xl
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16.r,
                    offset: Offset(0, 8.r),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // backdrop-filter: blur(10px)
                  child: Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingLg), // p-6
                    child: Stack(
                      children: [
                        // Centered content
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Quote text
                              Text(
                                widget.quote.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter', // Inter font for headings
                                  fontSize: 36.sp, // text-[36px] on md screens
                                  fontWeight: FontWeight.bold,
                                  height: 1.2, // leading-tight
                                  color: const Color(0xFF1E293B), // text-slate-800
                                ),
                              ),
                              SizedBox(height: DesignTokens.spacingLg),
                              // Source
                              Text(
                                widget.quote.source,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Lato', // Lato font for body
                                  fontSize: 18.sp, // text-[18px] on md screens
                                  fontWeight: FontWeight.normal,
                                  color: const Color(0xFF475569), // text-slate-600
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Share button
                        Positioned(
                          right: 24.r, // right-6
                          bottom: 24.r, // bottom-6
                          child: OpenContainer(
                            closedColor: Colors.transparent,
                            openColor: Colors.transparent,
                            closedBuilder: (context, action) {
                              return Container(
                                width: 56.r, // w-14
                                height: 56.r, // h-14
                                decoration: BoxDecoration(
                                  color: AppColors.primaryTeal, // var(--primary-color)
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4.r,
                                      offset: Offset(0, 2.r),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 32.r, // text-3xl equivalent
                                ),
                              );
                            },
                            openBuilder: (context, action) {
                              return ShareModal(
                                content: widget.quote.text,
                                title: 'Share Quote',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
