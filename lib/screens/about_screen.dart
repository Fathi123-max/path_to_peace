import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_nav.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulse1, _pulse2;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulse1 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulse2 = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulse2.value = 0.5;
  }

  @override
  void dispose() {
    _pulse1.dispose();
    _pulse2.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: isDark
          ? colorScheme.surface
          : const Color(0xFFFAFBFC),
      body: Stack(
        children: [
          // Subtle grid background
          Positioned.fill(
            child: CustomPaint(
              painter: GridPainter(color: Colors.grey.withOpacity(0.05)),
              size: Size.infinite,
            ),
          ),
          // Glass overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              ),
            ),
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
                    color: (isDark ? Colors.teal[900]! : Colors.teal[200]!)
                        .withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    ),
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
                    color: (isDark ? Colors.amber[900]! : Colors.amber[200]!)
                        .withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Opacity(
                    opacity: 0.3,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 64.h, bottom: 32.h),
                  child: Center(
                    child: Text(
                      'Discover Islam',
                      style: GoogleFonts.inter(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 192.w,
                      height: 192.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuDtJMhUT9TQdGcsqg8KHyg-Yf1pNI03Vk410Lm14a15BB_oM25KnoEk_R2C4EhQG1tlCeQhJKHBBtOk86Kjxr609UcbgEmv2R8kj-edJtKFr_rZxM3jgmjtZrYlUxANJdkrwM53X3BWN2lfglNBst-5npAg0fQ0Eg0yYMfnryp1KQftWrq-1YemS48fIJ8xLGT7F4Tq6AXdRZI_aT1Z2mh76DVCZOpVuysLtzUtUYj9w_AcpWq7yZy7C1uvDQncN0BKNqkYqdyWz_k',
                          ),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  'Welcome to Path to Peace. We\'re so glad you\'re here. This space is created with a warm heart for our friends and neighbors who are curious about Islam. It\'s a journey of discovery, offering a glimpse into the beliefs and values that inspire over a billion people worldwide to find tranquility and purpose.',
                  0,
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  'Our mission is simple: to share the beauty of Islamic teachings through inspiring quotes and verses. We believe in building bridges of understanding and fostering a spirit of open-mindedness. Think of this as a friendly conversation, a starting point for your own exploration.',
                  1,
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSection(
                  context,
                  'There are no strings attached, just an open invitation to reflect and learn. Whether you find a moment of peace, a spark of inspiration, or a new perspective, we hope this journey enriches your day.',
                  2,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 32.h),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        final Uri url = Uri.parse(
                          'mailto:support@pathtopeace.app?subject=I have a question!',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.w,
                          vertical: 16.h,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(32.r),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.contact_support,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Ask a Question',
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Add some bottom padding to ensure content isn't cut off by bottom nav
              SliverToBoxAdapter(child: SizedBox(height: 80.h)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String text, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 800 + (index * 200)),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surface.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Text(
              text,
              style: GoogleFonts.lato(
                fontSize: 16.sp,
                color: isDark ? Colors.grey[300] : const Color(0xFF374151),
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
