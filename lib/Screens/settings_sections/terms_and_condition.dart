import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import '../../services/terms_and_conditions_api.dart';

/// The Terms & Conditions screen displaying user agreements, digital service rules,
/// payment terms, auction rules, and company policies.
class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _termsData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await TermsAndConditionsApiService.fetchTermsAndConditions();
    if (mounted) {
      setState(() {
        if (response != null && response['error'] == false) {
          _termsData = response['sections'];
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Exact style specifications matching Privacy Policy
    final TextStyle titleStyle = GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      height: 21.92 / 12,
      letterSpacing: 0,
      color: AppColors.policyTitle,
    );

    final TextStyle bodyStyle = GoogleFonts.inter(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 21.92 / 12,
      letterSpacing: 0,
      color: AppColors.policyBody,
    );

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.appBarIcon,
            size: 22.r,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        titleSpacing: 0,
        title: Text(
          _termsData?['title'] ?? '',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.appBarTitle,
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _termsData == null
                ? const Center(child: Text('Failed to load terms and conditions'))
                : ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      overscroll: false,
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 36.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_termsData?['published'] != null)
                              Text(
                                _termsData!['published'].toString(),
                                style: bodyStyle,
                              ),
                            if (_termsData?['published'] != null)
                              SizedBox(height: 14.h),
                            
                            if (_termsData?['intro'] != null)
                              Text(
                                _termsData!['intro'].toString(),
                                style: bodyStyle,
                              ),
                            if (_termsData?['intro'] != null)
                              SizedBox(height: 10.h),

                            if (_termsData?['sections'] != null)
                              ...(_termsData!['sections'] as List).asMap().entries.map((entry) {
                                final isLast = entry.key == (_termsData!['sections'] as List).length - 1;
                                final section = entry.value;
                                return _buildSection(
                                  title: section['heading'] ?? '',
                                  content: section['content'] ?? '',
                                  titleStyle: titleStyle,
                                  bodyStyle: bodyStyle,
                                  isLast: isLast,
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }

  /// Builds a section with a semi-bold title and regular body text.
  Widget _buildSection({
    required String title,
    required String content,
    required TextStyle titleStyle,
    required TextStyle bodyStyle,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty)
            Text(
              title,
              style: titleStyle,
            ),
          if (title.isNotEmpty) SizedBox(height: 2.h),
          if (content.isNotEmpty)
            Text(
              content,
              style: bodyStyle,
            ),
        ],
      ),
    );
  }
}
