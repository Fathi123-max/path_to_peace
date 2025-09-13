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
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
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
      appBar: AppBar(
        title: const Text('Ask a Question'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
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
            child: _isSubmitted
                ? _buildSuccessState()
                : _buildQuestionForm(),
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
          Container(
            padding: EdgeInsets.all(DesignTokens.spacingLg),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignTokens.radiusLg),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Icon(
                  Icons.check_circle,
                  size: 80.r,
                  color: Colors.green,
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
              color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
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
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                        ? Colors.black.withOpacity(0.2) 
                        : Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Icon(
                      Icons.question_answer,
                      size: 32.r,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ),
              SizedBox(width: DesignTokens.spacingMd),
              Expanded(
                child: Text(
                  'Have a question about Islam?',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Submit your question and an expert will provide you with an answer.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          SizedBox(height: DesignTokens.spacingLg),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
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
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Your Name',
                    labelStyle: TextStyle(
                      color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
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
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Your Email',
                    labelStyle: TextStyle(
                      color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
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
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.glassDark : AppColors.glassLight,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
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
              borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Your Question',
                    labelStyle: TextStyle(
                      color: isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  style: TextStyle(
                    color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
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
              ),
            ),
          ),
          SizedBox(height: DesignTokens.spacingLg),
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
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Question'),
            ),
          ),
        ],
      ),
    );
  }
}
