import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/faq_card.dart';
import '../models/faq.dart';
import '../services/api_service.dart';
import '../services/local_cache.dart';
import '../theme/colors.dart';
import '../theme/design_tokens.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  List<Faq>? _faqs;
  bool _isLoading = true;
  bool _isError = false;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    try {
      // Try to fetch from API first
      List<Faq>? faqs = await ApiService.fetchFaqs();
      
      if (faqs == null || faqs.isEmpty) {
        // If API fails, try local cache
        faqs = await LocalCache.getCachedFaqs();
      }
      
      if (faqs == null || faqs.isEmpty) {
        // If no cached FAQs, use from local JSON
        // This would normally be loaded from the JSON asset
        faqs = [
          Faq(
            id: "1",
            question: "What does Islam say about peace?",
            answer: "Islam, which literally means 'submission' (to God) and 'peace,' places a strong emphasis on peace. The Quran states, 'And if they incline to peace, then incline to it [also] and rely upon Allah' (8:61). Muslims are encouraged to seek peace and reconciliation whenever possible.",
          ),
          Faq(
            id: "2",
            question: "Do Muslims believe in Jesus?",
            answer: "Yes, Muslims hold Jesus (Isa in Arabic) in high regard as one of the great prophets. The Quran mentions Jesus 25 times and confirms his virgin birth. However, Muslims do not believe that Jesus is divine or the son of God, but rather a messenger of God.",
          ),
        ];
      } else {
        // Cache the FAQs for offline use
        await LocalCache.cacheFaqs(faqs);
      }
      
      setState(() {
        _faqs = faqs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: DesignTokens.spacingMd),
                Text(
                  'Frequently Asked Questions',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: DesignTokens.spacingLg),
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState()
                      : _isError
                          ? _buildErrorState()
                          : _faqs != null
                              ? _buildFAQList()
                              : _buildEmptyState(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primaryTeal,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Loading FAQs...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.r,
            color: AppColors.error,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Failed to load FAQs',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          ElevatedButton(
            onPressed: _loadFaqs,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_mark,
            size: 60.r,
            color: AppColors.neutralGray,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'No FAQs available',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQList() {
    return ListView.separated(
      itemCount: _faqs!.length,
      separatorBuilder: (context, index) => SizedBox(height: DesignTokens.spacingMd),
      itemBuilder: (context, index) {
        return FAQCard(
          faq: _faqs![index],
          isExpanded: _expandedIndex == index,
          onTap: () => _toggleExpansion(index),
        );
      },
    );
  }
}