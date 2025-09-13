import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import '../theme/colors.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
        color: isDarkMode 
          ? AppColors.glassDark 
          : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
              ? Colors.black.withOpacity(0.2) 
              : Colors.black.withOpacity(0.05), 
            blurRadius: 16, 
            offset: Offset(0, -4)
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                for (int i = 0; i < 4; i++) Expanded(
                  child: GestureDetector(
                    onTap: () {
                      widget.onTap(i);
                      setState(() {}); // Navigate logic here
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, 
                      children: [
                        Transform.scale(
                          scale: widget.currentIndex == i ? 1.1 : 1.0,
                          child: Icon(
                            i == 0 ? Icons.home : i == 1 ? Icons.help_outline : i == 2 ? Icons.question_answer : Icons.info_outline,
                            color: widget.currentIndex == i 
                              ? AppColors.primaryTeal 
                              : isDarkMode 
                                ? AppColors.textSecondaryDark 
                                : AppColors.neutralGray, 
                            size: 28.sp
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: widget.currentIndex == i ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 300),
                          child: Text(
                            ['Home', 'FAQ', 'Questions', 'About'][i], 
                            style: TextStyle(
                              fontSize: 12.sp, 
                              fontWeight: FontWeight.w500, 
                              color: isDarkMode 
                                ? AppColors.textPrimaryDark 
                                : AppColors.primaryTeal
                            )
                          ),
                        ),
                      ]
                    ),
                  )
                ),
              ]
            ),
          )
        ),
      ),
    );
  }
}
