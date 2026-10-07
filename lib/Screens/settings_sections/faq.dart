import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'app_colors.dart';
import '../../services/faq_api.dart';

import '../Home_Sections/drawers_screen.dart';

/// The FAQ Screen displaying expandable questions, answers, and
/// a "Still have a question?" contact support banner.
class FAQScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const FAQScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  // Item 0 (Question 1) is expanded by default as shown in the design
  final Set<int> _expandedIndices = {0};

  List<_FAQItem> _faqItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFaq();
  }

  Future<void> _fetchFaq() async {
    final response = await FaqApiService.fetchFaq();
    setState(() {
      _isLoading = false;
      if (response != null && response['error'] == false) {
        final List<dynamic> faqList = response['faq'];
        _faqItems = faqList.map((item) => _FAQItem(
          number: int.tryParse(item['id'].toString()) ?? 0,
          question: item['question'].toString(),
          answer: item['answer'].toString(),
        )).toList();
      } else {
        _errorMessage = response?['error_msg'] ?? 'Failed to load FAQs';
      }
    });
  }

  void _toggleExpand(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Exact typographic styles per specifications
    final TextStyle numberStyle = TextStyle(
      fontFamily: 'Liberation Sans',
      fontFamilyFallback: const ['Inter', 'sans-serif'],
      fontSize: 13.08.sp,
      fontWeight: FontWeight.w700,
      height: 18.69 / 13.08,
      letterSpacing: 0,
      color: AppColors.faqNumberText,
    );

    final TextStyle questionStyle = TextStyle(
      fontFamily: 'Liberation Sans',
      fontFamilyFallback: const ['Inter', 'sans-serif'],
      fontSize: 12.61.sp,
      fontWeight: FontWeight.w600,
      height: 17.34 / 12.61,
      letterSpacing: 0,
      color: AppColors.faqQuestionText,
    );

    final TextStyle answerStyle = TextStyle(
      fontFamily: 'Liberation Sans',
      fontFamilyFallback: const ['Inter', 'sans-serif'],
      fontSize: 12.15.sp,
      fontWeight: FontWeight.w400,
      height: 19.74 / 12.15,
      letterSpacing: 0,
      color: AppColors.faqAnswerText,
    );

    return PopScope(
      canPop: !_isDrawerOpen,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_isDrawerOpen) {
          _scaffoldKey.currentState?.closeDrawer();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.screenBackground,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
              size: 24.sp,
            ),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          title: Text(
            'FAQ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              color: AppColors.appBarDivider,
              height: 1.h,
            ),
          ),
        ),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            overscroll: false,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 36.h),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // FAQ Accordion Cards
                  if (_isLoading)
                    Center(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      child: const CircularProgressIndicator(),
                    ))
                  else if (_errorMessage != null)
                    Center(child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                    ))
                  else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _faqItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemBuilder: (context, index) {
                      final item = _faqItems[index];
                      final isExpanded = _expandedIndices.contains(index);

                      return _buildFAQCard(
                        item: item,
                        isExpanded: isExpanded,
                        onTap: () => _toggleExpand(index),
                        numberStyle: numberStyle,
                        questionStyle: questionStyle,
                        answerStyle: answerStyle,
                      );
                    },
                  ),
                  SizedBox(height: 18.h),

                  // Bottom Support Banner: "Still have a question?"
                  _buildStillHaveQuestionCard(context),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  /// Builds an individual FAQ card with rounded corners, number badge,
  /// question, chevron arrow, and expandable answer box (#EEFAF4).
  Widget _buildFAQCard({
    required _FAQItem item,
    required bool isExpanded,
    required VoidCallback onTap,
    required TextStyle numberStyle,
    required TextStyle questionStyle,
    required TextStyle answerStyle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.faqCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.faqCardBorder,
          width: 0.9.w,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.faqCardShadow,
            offset: Offset(0, 1),
            blurRadius: 3,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Number Badge + Question + Chevron
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Number circular badge
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.faqNumberBg,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${item.number}',
                        style: numberStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Question text
                    Expanded(
                      child: Text(
                        item.question,
                        style: questionStyle,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Chevron arrow up/down
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 22.r,
                      color: AppColors.faqChevron,
                    ),
                  ],
                ),

                // Expanded Answer Container with bg color #EEFAF4
                if (isExpanded) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.faqAnswerBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      item.answer,
                      style: answerStyle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the "Still have a question?" contact card with headphone icon
  /// and "Contact Support →" outlined button.
  Widget _buildStillHaveQuestionCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.faqSupportCardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.faqSupportCardBorder,
          width: 1.w,
        ),
      ),
      child: Row(
        children: [
          // Circular headphone icon badge
          Container(
            width: 44.r,
            height: 44.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.faqSupportHeadphoneBg,
            ),
            padding: EdgeInsets.all(10.r),
            child: Image.asset(
              'assets/faq/contact_support.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 12.w),

          // Titles column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Still have a\nquestion?',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.faqSupportTitle,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'We\'re here to help you.',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.faqSupportSubtext,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          // "Contact Support →" pill button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20.r),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NeedHelpScreen(),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.faqSupportButtonBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: AppColors.faqSupportButtonBorder,
                    width: 1.2.w,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Contact Support',
                      style: GoogleFonts.inter(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.faqSupportButtonText,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 14.r,
                      color: AppColors.faqSupportButtonText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model representing an FAQ item.
class _FAQItem {
  final int number;
  final String question;
  final String answer;

  const _FAQItem({
    required this.number,
    required this.question,
    required this.answer,
  });
}
