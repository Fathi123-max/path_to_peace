import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/faq_card.dart';
import '../models/faq.dart';
import '../services/api_service.dart';
import '../services/local_cache.dart';
import '../theme/design_tokens.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> with TickerProviderStateMixin {
  List<Faq>? _faqs;
  bool _isLoading = true;
  bool _isError = false;
  int _expandedIndex = -1;
  late AnimationController _pulse1, _pulse2;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
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
          Faq(
            id: "3",
            question: "Who is God in Islam?",
            answer: "In Islam, God, known as Allah, is the one, unique, and incomparable creator and sustainer of the universe. He is described as all-merciful, all-powerful, and eternal. Islam emphasizes that God is beyond human comprehension and has no partners, children, or equals.",
          ),
          Faq(
            id: "4",
            question: "What is the Quran?",
            answer: "The Quran is the holy book of Islam, believed by Muslims to be the literal word of God (Allah) as revealed to the Prophet Muhammad over a period of 23 years. It is the central religious text of Islam, guiding Muslims in all aspects of life.",
          ),
          Faq(
            id: "5",
            question: "Who is Muhammad?",
            answer: "Muhammad is considered the final prophet of God in Islam. Muslims believe he received revelations from God, which form the Quran. He is seen as a role model for his exemplary character and teachings, but he is not worshipped.",
          ),
          Faq(
            id: "6",
            question: "Do Muslims worship Muhammad?",
            answer: "No, Muslims do not worship Muhammad or any other prophet. They worship only God (Allah). Muhammad is highly respected as God's final messenger, but he is considered a human being. Attributing divinity to anyone or anything other than God is a major sin in Islam.",
          ),
          Faq(
            id: "7",
            question: "What does Islam say about women?",
            answer: "Islam grants women full rights and equality in spiritual, legal, and social matters. The Quran emphasizes the equal value of men and women before God. Practices like veiling stem from modesty, not degradation.",
          ),
          Faq(
            id: "8",
            question: "Is Islam compatible with modernity?",
            answer: "Yes, Islam encourages science, reasoning, and innovation, as seen in the Golden Age of Islam. It aligns with modern advancements while maintaining ethical principles.",
          ),
        ];
      } else {
        // Cache the FAQs for offline use
        await LocalCache.cacheFaqs(faqs);
      }
      
      setState(() {
        _faqs = faqs;
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

  void _toggleExpansion(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? -1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: isDarkMode ? colorScheme.surface : const Color(0xFFFAFBFC),
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
                    color: colorScheme.primary.withOpacity(0.3), 
                    shape: BoxShape.circle
                  )
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
                  )
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(DesignTokens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DesignTokens.spacingMd),
                  Text(
                    'Curious about Islam? Start here.',
                    style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
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
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colorScheme.primary,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Loading FAQs...',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60.r,
            color: colorScheme.error,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'Failed to load FAQs',
            style: textTheme.bodyLarge,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          ElevatedButton(
            onPressed: _loadFaqs,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_mark,
            size: 60.r,
            color: colorScheme.outline,
          ),
          SizedBox(height: DesignTokens.spacingMd),
          Text(
            'No FAQs available',
            style: textTheme.bodyLarge,
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