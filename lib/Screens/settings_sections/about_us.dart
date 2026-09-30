import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

import '../../services/about_us_api.dart';

/// The About Us screen displaying the company's background, mission,
/// vision, and core values matching the design.
class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Map<String, dynamic>? _aboutData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAboutUs();
  }

  Future<void> _fetchAboutUs() async {
    final response = await AboutUsApiService.fetchAboutUs();
    setState(() {
      _isLoading = false;
      if (response != null && response['error'] == false) {
        _aboutData = response['about_us'];
      } else {
        _errorMessage = response?['error_msg'] ?? 'Failed to load About Us';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Exact typographic styles matching the design specifications
    final TextStyle introStyle = GoogleFonts.inter(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      height: 1.45,
      color: AppColors.aboutIntroText,
      letterSpacing: -0.1,
    );

    final TextStyle headingStyle = GoogleFonts.inter(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      height: 1.3,
      color: AppColors.aboutHeading,
      letterSpacing: -0.1,
    );

    final TextStyle bodyStyle = GoogleFonts.inter(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.aboutBody,
      letterSpacing: 0,
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
          'About Us',
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
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            overscroll: false,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 36.h),
            child: SizedBox(
              width: double.infinity,
              child: _isLoading 
                  ? Center(child: CircularProgressIndicator())
                  : _errorMessage != null 
                      ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Green Intro Paragraph
                            Text(
                              _aboutData?['intro']?.toString() ?? '',
                              style: introStyle,
                            ),
                            SizedBox(height: 20.h),

                            // 2. Who We Are
                            if (_aboutData?['who_we_are'] != null)
                              _buildSection(
                                title: 'Who We Are',
                                content: _aboutData!['who_we_are'].toString(),
                                headingStyle: headingStyle,
                                bodyStyle: bodyStyle,
                              ),

                            // 3. Our Mission
                            if (_aboutData?['mission'] != null)
                              _buildSection(
                                title: 'Our Mission',
                                content: _aboutData!['mission'].toString(),
                                headingStyle: headingStyle,
                                bodyStyle: bodyStyle,
                              ),

                            // 4. Our Vision
                            if (_aboutData?['vision'] != null)
                              _buildSection(
                                title: 'Our Vision',
                                content: _aboutData!['vision'].toString(),
                                headingStyle: headingStyle,
                                bodyStyle: bodyStyle,
                              ),

                            // 5. Our Values
                            if (_aboutData?['values'] != null || _aboutData?['tagline'] != null)
                              _buildSection(
                                title: 'Our Values',
                                content: '${(_aboutData?['values'] as List<dynamic>?)?.join(' • ') ?? ''} ${_aboutData?['tagline'] ?? ''}'.trim(),
                                headingStyle: headingStyle,
                                bodyStyle: bodyStyle,
                                isLast: true,
                              ),
                          ],
                        ),
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget to build each heading + content section.
  Widget _buildSection({
    required String title,
    required String content,
    required TextStyle headingStyle,
    required TextStyle bodyStyle,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: headingStyle,
          ),
          SizedBox(height: 5.h),
          Text(
            content,
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}
