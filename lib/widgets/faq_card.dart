import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import '../models/faq.dart';
import '../theme/colors.dart';
import '../theme/design_tokens.dart';
import '../theme/typography.dart';

class FAQCard extends StatefulWidget {
  final Faq faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const FAQCard({
    super.key,
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant FAQCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shareFAQ() {
    Share.share('${widget.faq.question}\n\n${widget.faq.answer}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20.r,
            offset: Offset(0, 10.r),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question header
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(DesignTokens.spacingLg),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.faq.question,
                            style: AppTypography.headlineSmall(
                              context,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(width: DesignTokens.spacingSm),
                        RotationTransition(
                          turns: _rotateAnimation,
                          child: Icon(
                            Icons.expand_more,
                            color: AppColors.neutralGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Answer body
              SizeTransition(
                sizeFactor: _sizeAnimation,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.7),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      DesignTokens.spacingLg,
                      DesignTokens.spacingSm,
                      DesignTokens.spacingLg,
                      DesignTokens.spacingLg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.faq.answer,
                          style: AppTypography.bodyMedium(context),
                        ),
                        SizedBox(height: DesignTokens.spacingMd),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _shareFAQ,
                            child: Container(
                              width: DesignTokens.buttonHeight,
                              height: DesignTokens.buttonHeight,
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: DesignTokens.iconSm,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
