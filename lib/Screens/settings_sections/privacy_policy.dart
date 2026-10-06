import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/privacy_policy_api.dart';
import 'app_colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _policyData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await PrivacyPolicyApiService.fetchPrivacyPolicy();
    if (mounted) {
      setState(() {
        if (response != null && response['error'] == false) {
          _policyData = response['sections'];
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _policyData?['title'] ?? '',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
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
            : _policyData == null
                ? const Center(child: Text('Failed to load privacy policy'))
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
                            if (_policyData?['published'] != null)
                              Text(
                                _policyData!['published'].toString(),
                                style: bodyStyle,
                              ),
                            if (_policyData?['published'] != null)
                              SizedBox(height: 14.h),
                            
                            if (_policyData?['intro'] != null)
                              Text(
                                _policyData!['intro'].toString(),
                                style: bodyStyle,
                              ),
                            if (_policyData?['intro'] != null)
                              SizedBox(height: 10.h),

                            if (_policyData?['sections'] != null)
                              ...(_policyData!['sections'] as List).asMap().entries.map((entry) {
                                final isLast = entry.key == (_policyData!['sections'] as List).length - 1;
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
