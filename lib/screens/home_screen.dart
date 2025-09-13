import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';
import '../services/api_service.dart';
import '../services/local_cache.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Quote? _quote;
  bool _isLoading = true;
  bool _isError = false;
  late AnimationController _pulse1;
  late AnimationController _pulse2;

  @override
  void initState() {
    super.initState();
    _loadQuote();
    _pulse1 = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulse2 = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulse2.value = 0.5;
  }

  @override
  void dispose() {
    _pulse1.dispose();
    _pulse2.dispose();
    super.dispose();
  }

  Future<void> _loadQuote() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Try to fetch from API first
      Quote? quote = await ApiService.fetchQuoteOfTheDay();
      
      quote ??= await LocalCache.getCachedQuote();
      
      if (quote == null) {
        // If no cached quote, use first from local JSON
        // This would normally be loaded from the JSON asset
        quote = Quote(
          id: "1",
          text: "The best among you are those who have the best character.",
          source: "Prophet Muhammad (ﷺ)",
        );
      } else {
        // Cache the quote for offline use
        await LocalCache.cacheQuote(quote);
      }
      
      setState(() {
        _quote = quote;
        _isLoading = false;
        _isError = false;
      });
    } on ApiException catch (e) {
      // Handle API exceptions
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      // Could show a snackbar or dialog with the error message
      if (e.statusCode == 429) {
        // Handle rate limiting specifically
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Too many requests. Please try again later.')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  Future<void> _loadRandomQuote() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Try to fetch a random quote from API
      Quote? quote = await ApiService.fetchRandomQuote();
      
      quote ??= await LocalCache.getCachedQuote();
      
      if (quote == null) {
        // If no cached quote, use first from local JSON
        // This would normally be loaded from the JSON asset
        quote = Quote(
          id: "1",
          text: "The best among you are those who have the best character.",
          source: "Prophet Muhammad (ﷺ)",
        );
      } else {
        // Cache the quote for offline use
        await LocalCache.cacheQuote(quote);
      }
      
      setState(() {
        _quote = quote;
        _isLoading = false;
        _isError = false;
      });
    } on ApiException catch (e) {
      // Handle API exceptions
      setState(() {
        _isLoading = false;
        _isError = true;
      });
      // Could show a snackbar or dialog with the error message
      if (e.statusCode == 429) {
        // Handle rate limiting specifically
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Too many requests. Please try again later.')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: isDarkMode 
              ? AppColors.backgroundDark 
              : const Color(0xFFFAFBFC)
          ),
          // Background pulses
          Positioned(
            top: -ScreenUtil().screenHeight * 0.25,
            left: -ScreenUtil().screenWidth * 0.25,
            child: AnimatedBuilder(
              animation: _pulse1,
              builder: (_, __) => Transform.scale(
                scale: 1 + (_pulse1.value * 0.2),
                child: Container(
                  width: 384.w, 
                  height: 384.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withOpacity(0.3), 
                    shape: BoxShape.circle
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -ScreenUtil().screenHeight * 0.25,
            right: -ScreenUtil().screenWidth * 0.25,
            child: AnimatedBuilder(
              animation: _pulse2,
              builder: (_, __) => Transform.scale(
                scale: 1 + (_pulse2.value * 0.2),
                child: Container(
                  width: 384.w, 
                  height: 384.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6C85F).withOpacity(0.3), 
                    shape: BoxShape.circle
                  ),
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 448.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 500.h,
                      decoration: BoxDecoration(
                        color: isDarkMode 
                          ? AppColors.glassDark 
                          : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode 
                              ? Colors.black.withOpacity(0.2) 
                              : Colors.black.withOpacity(0.05), 
                            blurRadius: 20, 
                            offset: Offset(0, 10)
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.r),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    _quote?.text ?? "The best among you are those who have the best character.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 28.sp, 
                                      fontWeight: FontWeight.w700, 
                                      color: isDarkMode 
                                        ? AppColors.textPrimaryDark 
                                        : const Color(0xFF334155),
                                      height: 1.2
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                Text(
                                  _quote?.source ?? "Prophet Muhammad (ﷺ)", 
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(
                                    fontSize: 16.sp, 
                                    color: isDarkMode 
                                      ? AppColors.textSecondaryDark 
                                      : const Color(0xFF64748B)
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Share button
          Positioned(
            bottom: 100.h, 
            right: 16.w, 
            child: GestureDetector(
              onTap: () => Share.share(_quote != null 
                  ? '${_quote!.text} - ${_quote!.source}' 
                  : 'The best among you are those who have the best character. - Prophet Muhammad (ﷺ)'),
              child: Container(
                width: 56.w, 
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal, 
                  shape: BoxShape.circle, 
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                        ? Colors.black.withOpacity(0.3) 
                        : Colors.black.withOpacity(0.1), 
                      blurRadius: 4, 
                      offset: Offset(0, 2)
                    )
                  ]
                ),
                child: Icon(
                  Icons.share, 
                  color: Colors.white, 
                  size: 24.sp
                ),
              ),
            )
          ),
          // Random quote button
          Positioned(
            bottom: 100.h, 
            left: 16.w, 
            child: GestureDetector(
              onTap: _loadRandomQuote,
              child: Container(
                width: 56.w, 
                height: 56.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal, 
                  shape: BoxShape.circle, 
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                        ? Colors.black.withOpacity(0.3) 
                        : Colors.black.withOpacity(0.1), 
                      blurRadius: 4, 
                      offset: Offset(0, 2)
                    )
                  ]
                ),
                child: Icon(
                  Icons.autorenew, 
                  color: Colors.white, 
                  size: 24.sp
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}