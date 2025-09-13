import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import '../services/api_service.dart';
import '../theme/colors.dart';
import '../theme/design_tokens.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _questionController = TextEditingController();

  bool _isLoading = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuestion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await ApiService.submitQuestion(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        question: _questionController.text.trim(),
      );

      if (success) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Your question has been submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Clear form
        _nameController.clear();
        _emailController.clear();
        _questionController.clear();
      } else {
        setState(() {
          _isLoading = false;
        });

        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to submit question. Please try again.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } on ApiException catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show specific error message
      String message = e.message;
      if (e.statusCode == 429) {
        message = 'Too many requests. Please try again later.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show generic error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.spacingMd),
            child: _isSubmitted ? _buildSuccessState() : _buildQuestionForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon with glassmorphism effect
          Container(
            padding: EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.glassDark.withOpacity(0.7)
                  : AppColors.glassLight.withOpacity(0.7),
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.2)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusXl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Icon(
                  Icons.check_circle,
                  size: 80.r,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingXl),
          Text(
            'Thank You!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.primaryTeal,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Your question has been submitted successfully.\nAn expert will answer it soon.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDarkMode
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          SizedBox(height: DesignTokens.spacingXl),
          SizedBox(
            width: double.infinity,
            height: DesignTokens.buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isSubmitted = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                elevation: 4,
              ),
              child: const Text('Ask Another Question'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionForm() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with glassmorphism effect
            Container(
              padding: EdgeInsets.all(DesignTokens.spacingMd),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.glassDark.withOpacity(0.7)
                    : AppColors.glassLight.withOpacity(0.7),
                borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
                boxShadow: [
                  BoxShadow(
                    color: isDarkMode
                        ? Colors.black.withOpacity(0.2)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusMd,
                      ),
                    ),
                    child: Icon(
                      Icons.question_answer_outlined,
                      size: 32.r,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  SizedBox(width: DesignTokens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Have a question about Islam?',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Submit your question and an expert will provide you with an answer.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DesignTokens.spacingLg),

            // Name input field
            _buildInputField(
              controller: _nameController,
              labelText: 'Your Name',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: DesignTokens.spacingMd),

            // Email input field
            _buildInputField(
              controller: _emailController,
              labelText: 'Your Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: DesignTokens.spacingMd),

            // Question input field
            _buildInputField(
              controller: _questionController,
              labelText: 'Your Question',
              prefixIcon: Icons.question_answer_outlined,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your question';
                }
                if (value.trim().length < 10) {
                  return 'Question must be at least 10 characters';
                }
                return null;
              },
            ),
            SizedBox(height: DesignTokens.spacingLg),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: DesignTokens.buttonHeight,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  ),
                  elevation: 4,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an input field with consistent styling
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDarkMode ? AppColors.neutralGray.withOpacity(0.3) : AppColors.neutralGray.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                  ? Colors.black.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(
                prefixIcon,
                color: AppColors.primaryTeal,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
            ),
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
