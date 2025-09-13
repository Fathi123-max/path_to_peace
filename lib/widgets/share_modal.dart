import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';
import '../theme/design_tokens.dart';
import '../theme/typography.dart';

class ShareModal extends StatefulWidget {
  final String content;
  final String title;

  const ShareModal({super.key, required this.content, required this.title});

  @override
  State<ShareModal> createState() => _ShareModalState();
}

class _ShareModalState extends State<ShareModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isCopied = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.content));
    setState(() {
      _isCopied = true;
    });
    _animationController.forward().then((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCopied = false;
          });
          _animationController.reset();
        }
      });
    });
  }

  void _shareContent() {
    Share.share(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 300.h,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(DesignTokens.radiusXl),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(DesignTokens.spacingLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: AppTypography.headlineMedium,
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.close,
                              size: DesignTokens.iconMd,
                              color: textTheme.bodyLarge?.color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: DesignTokens.spacingMd),
                      // Content preview
                      Container(
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(
                            DesignTokens.radiusMd,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(DesignTokens.spacingSm),
                          child: Text(
                            widget.content,
                            style: AppTypography.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: DesignTokens.spacingLg),
                      // Share options
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildShareOption(
                            icon: Icons.copy,
                            label: _isCopied ? 'Copied!' : 'Copy Text',
                            onTap: _copyToClipboard,
                            isSpecial: _isCopied,
                          ),
                          _buildShareOption(
                            icon: Icons.share,
                            label: 'Share',
                            onTap: _shareContent,
                          ),
                          _buildShareOption(
                            icon: Icons.chat,
                            label: 'WhatsApp',
                            onTap: () => Share.share(
                              widget.content,
                              sharePositionOrigin: Rect.fromLTWH(
                                0,
                                0,
                                300.w,
                                400.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSpecial = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 60.r,
            height: 60.r,
            decoration: BoxDecoration(
              color: isSpecial
                  ? const Color(0xFF10B981)  // success color
                  : colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isSpecial
                  ? Lottie.asset(
                      'assets/lottie/check.json',
                      width: 30.r,
                      height: 30.r,
                      controller: _animationController,
                      onLoaded: (composition) {
                        _animationController.duration = composition.duration;
                      },
                    )
                  : Icon(
                      icon,
                      color: isSpecial
                          ? Colors.white
                          : colorScheme.primary,
                      size: DesignTokens.iconMd,
                    ),
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacingXs),
        Text(label, style: AppTypography.labelSmall),
      ],
    );
  }
}
