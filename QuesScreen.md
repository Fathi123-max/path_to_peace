```dart
// lib/screens/ask_question_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/bottom_nav.dart';

class AskQuestionScreen extends StatefulWidget {
  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _questionController = TextEditingController();
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  late AnimationController _pulse1, _pulse2;

  @override
  void initState() {
    super.initState();
    _pulse1 = AnimationController(duration: Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulse2 = AnimationController(duration: Duration(seconds: 2), vsync: this)..repeat(reverse: true);
    _pulse2.value = 0.5;
  }

  @override
  void dispose() {
    _pulse1.dispose();
    _pulse2.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required.';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) return 'Please enter a valid email address.';
    return null;
  }

  String? _validateQuestion(String? value) {
    if (value == null || value.trim().length < 10) return 'Question must be at least 10 characters long.';
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(Duration(milliseconds: 1500));
      final body = 'Name: ${_nameController.text}\nEmail: ${_emailController.text}\nQuestion: ${_questionController.text}';
      final uri = Uri(
        scheme: 'mailto',
        path: 'support@pathtopeace.app',
        query: EncodingMode.utf8.encodeComponent('subject=I have a question!&body=$body'),
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8.w),
              Expanded(child: Text('Your question has been sent successfully!')),
            ],
          ),
          backgroundColor: Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ));
        _formKey.currentState?.reset();
        _nameController.clear();
        _emailController.clear();
        _questionController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: isDark ? Color(0xFF121212) : Color(0xFFFAFBFC),
        body: Stack(
          children: [
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
                      color: (isDark ? Colors.teal[900]! : Colors.teal[200]!).withOpacity(0.3),
                      shape: BoxShape.circle,
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
                      color: (isDark ? Colors.amber[900]! : Colors.amber[200]!).withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color(0xFF0F172A).withOpacity(0.2),
                            Colors.transparent,
                            Color(0xFF92400E).withOpacity(0.2),
                          ]
                        : [
                            Color(0xFF0EEAA4).withOpacity(0.5),
                            Colors.white.withOpacity(0.3),
                            Color(0xFFF6C85F).withOpacity(0.5),
                          ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 448.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.contact_support,
                            size: 48.sp,
                            color: Color(0xFF0EA5A4),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Ask a Question',
                            style: GoogleFonts.inter(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'We are happy to answer your curiosity.',
                            style: GoogleFonts.lato(
                              fontSize: 18.sp,
                              color: isDark ? Color(0xFFD1D5DB) : Color(0xFF6B7280),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name *',
                              filled: true,
                              fillColor: (isDark ? Colors.grey[800]! : Colors.white).withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444), width: 2),
                              ),
                              contentPadding: EdgeInsets.all(16.w),
                              prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                            validator: _validateName,
                            style: GoogleFonts.lato(fontSize: 16.sp, color: isDark ? Colors.white : Color(0xFF111827)),
                          ),
                          if (_formKey.currentState?.fields['name']?.errorText != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formKey.currentState!.fields['name']!.errorText!,
                                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 12.sp),
                                ),
                              ),
                            ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email *',
                              filled: true,
                              fillColor: (isDark ? Colors.grey[800]! : Colors.white).withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444), width: 2),
                              ),
                              contentPadding: EdgeInsets.all(16.w),
                            ),
                            validator: _validateEmail,
                            style: GoogleFonts.lato(fontSize: 16.sp, color: isDark ? Colors.white : Color(0xFF111827)),
                          ),
                          if (_formKey.currentState?.fields['email']?.errorText != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formKey.currentState!.fields['email']!.errorText!,
                                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 12.sp),
                                ),
                              ),
                            ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: _questionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: 'Your Question (min. 10 characters) *',
                              filled: true,
                              fillColor: (isDark ? Colors.grey[800]! : Colors.white).withOpacity(0.5),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide.none,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444)),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.r),
                                borderSide: BorderSide(color: Color(0xFFEF4444), width: 2),
                              ),
                              contentPadding: EdgeInsets.all(16.w),
                            ),
                            validator: _validateQuestion,
                            style: GoogleFonts.lato(fontSize: 16.sp, color: isDark ? Colors.white : Color(0xFF111827)),
                          ),
                          if (_formKey.currentState?.fields['question']?.errorText != null)
                            Padding(
                              padding: EdgeInsets.only(top: 4.h, left: 16.w),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  _formKey.currentState!.fields['question']!.errorText!,
                                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 12.sp),
                                ),
                              ),
                            ),
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            height: 56.h,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading ? Color(0xFF14B8A6) : Color(0xFF0EA5A4),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: isDark ? Color(0xFF1E293B) : Color(0xFFCBD5E1),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 24.w,
                                      height: 24.h,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.w,
                                      ),
                                    )
                                  : Text(
                                      'Submit Question',
                                      style: GoogleFonts.inter(fontSize: 18.sp, fontWeight: FontWeight.w700),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNav(currentIndex: 2),
      ),
    );
  }
}
```

Tailwind → Flutter: `.form-input` → `TextFormField` + `InputDecoration` (opacity fill, rounded 24.r, focus shadow via style); `.is-invalid` → errorBorder Color(0xFFEF4444); `.btn-submit` → `ElevatedButton` disabled state; `.loader` → `CircularProgressIndicator`; `.toast` → floating `SnackBar` green + icon. Validation: real-time via listeners if needed, but Form validator. Submission: mailto with body. Add to main routing.