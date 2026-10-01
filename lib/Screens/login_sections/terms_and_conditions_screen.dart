import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../main_wrapper.dart';
import '../first_time_main_wrapper.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final bool isNewUser;

  const TermsAndConditionsScreen({super.key, this.isNewUser = false});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _isAgreed = false;

  void _onAgreeAndContinue() {
    if (!_isAgreed) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Terms & Conditions Accepted!',
          style: GoogleFonts.inter(fontSize: 13.sp),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget.isNewUser
            ? const FirstTimeMainWrapper()
            : const MainWrapper(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 1. Fixed Top Header Row: Back Arrow + Title (Fixed at top, does NOT scroll)
          Container(
            color: AppColors.background,
            padding: EdgeInsets.only(
              left: 17.w,
              right: 17.w,
              top: statusBarHeight > 0 ? statusBarHeight + 10.h : 24.h,
              bottom: 10.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back button
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(20.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 2.w,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF000000),
                      size: 22,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Title "Terms & Condition" (Font: Inter, 16px, Regular 400, #000000)
                Text(
                  'Terms & Condition',
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // 2. Main content area with scrollable terms and fixed bottom action footer
          Expanded(
            child: Stack(
              children: [
                // Scrollable terms content
                Positioned.fill(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 17.w,
                      right: 17.w,
                      top: 10.h,
                      bottom: 165
                          .h, // Buffer so sticky bottom footer does not cover text
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildParagraph('Last Updated: [Date]'),
                        _buildParagraph('Effective from: [Date]'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'By registering, accessing or using the App, you agree to these Terms & Conditions. These Terms govern use of the App as a digital service channel.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 1
                        _buildSectionTitle(
                          '1. Eligibility, Registration & KYC',
                        ),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'The App is for eligible customers of the Company. You must provide accurate, complete and current information and complete applicable KYC/verification requirements. Registration or App access does not by itself create or guarantee membership in any chit group.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 2
                        _buildSectionTitle('2. Account & OTP Security'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'You are responsible for keeping your login credentials and OTPs confidential and for securing your device. Do not share OTPs, UPI PINs, card PINs or banking passwords. Report suspected unauthorized access to the Company promptly.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 3
                        _buildSectionTitle(
                          '3. Chit Information & Payment Obligations',
                        ),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'The App may display chit group details, installments, due dates, outstanding amounts, payment history, auction information, prize/bid information, discount/dividend details, receipts and statements. You remain responsible for paying installments and other applicable amounts on time in accordance with your chit agreement. App unavailability or non-receipt of a reminder does not by itself extend a due date.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 4
                        _buildSectionTitle('4. Online Payments, Failed Transactions & Refunds'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'Payments may be made through available digital methods and processed by third-party banks/payment providers. Where a convenience fee, payment gateway charge, processing fee or applicable tax is levied for using an online payment facility, the applicable charge shall be borne by the customer and will be displayed before payment confirmation, where applicable. Such charge is separate from the chit installment amount. A payment is treated as credited only after successful processing and reconciliation in the Company\'s records. If a transaction is pending, failed, duplicated, debited but not reflected, reversed or otherwise disputed, contact the Company with the transaction reference. Any refund, reversal or adjustment that is applicable will be processed after verification/reconciliation and subject to the applicable payment process, chit agreement and law.',
                      ),
                        SizedBox(height: 14.h),

                        // Section 5
                        _buildSectionTitle(
                          '5. Fees, Charges & Penalties',
                        ),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'Installments, charges, penalties, taxes or other amounts, where applicable, will be governed by the customer\'s chit agreement, applicable schedule/Company records and law. Nothing in these App Terms creates a new charge merely by mentioning a category of charge.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 6
                        _buildSectionTitle('6. Auction / Bidding Through the App'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'Where auction or bidding functionality is enabled, participation is limited to customers eligible under the applicable chit agreement and Company records. Auction timing, bidding method, permissible discount/bid limits, eligibility, successful bidder selection, security/collateral requirements, prize payment and dividend/discount treatment will be governed by the applicable chit agreement, Company procedures and applicable law. A bid submitted through the App may be treated as binding once validly recorded in accordance with the applicable auction rules. The Company may reject an invalid, unauthorized, late or non-compliant bid. If there is any conflict between an App display and the applicable chit agreement or legally maintained Company records, the chit agreement and applicable law will prevail, subject to correction of genuine errors.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 7
                        _buildSectionTitle('7. Digital Receipts, Records & Notifications'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'The App may provide electronic receipts, statements, payment confirmations and other records. The Company may send service communications through App notifications, SMS, email, WhatsApp or other permitted channels, where implemented. You should keep your registered contact information current and promptly report any material discrepancy in your account.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 8
                        _buildSectionTitle(
                          '8. App Availability',
                        ),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'We will make reasonable efforts to keep the App available, but temporary interruptions may occur due to maintenance, updates, network issues, banking/payment-provider failures, security events or circumstances beyond reasonable control. We do not guarantee uninterrupted or error-free operation.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 9
                        _buildSectionTitle('9. Prohibited Use'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'You must not use the App unlawfully; provide false or misleading information; access another person\'s account without authorization; manipulate bidding or payment functions; bypass security; introduce malicious code; misuse payment facilities; or copy, modify, reverse engineer or interfere with the App except where legally permitted.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 10
                        _buildSectionTitle('10. Privacy & Intellectual Property'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'Personal information is handled in accordance with the Company\'s Privacy Policy. The App, software, design, content, logos and other intellectual property are owned by or licensed to the Company. Your right to use the App is limited to legitimate customer-service purposes.'
                        ),
                        SizedBox(height: 14.h),

                        // Section 11
                        _buildSectionTitle('11. Suspension / Restriction'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'The Company may suspend or restrict App access where reasonably necessary for security, verification, maintenance, suspected fraud/misuse, legal requirements or violation of these Terms. Suspension of App access does not automatically cancel or terminate the underlying chit subscription or payment obligations.',
                        ),
                        SizedBox(height: 14.h),

                        // Section 12
                        _buildSectionTitle('12. Limitation of Liability'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'To the extent permitted by law, the Company is not responsible for loss caused solely by third-party payment/network failures, device problems, customer misuse or circumstances beyond its reasonable control. Nothing in these Terms excludes any liability or customer right that cannot legally be excluded or limited.'
                        ),
                        SizedBox(height: 14.h),

                        // Section 13
                        _buildSectionTitle(
                          '13. Changes to Terms',
                        ),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'The Company may update these Terms to reflect changes in the App, services, security, technology or applicable law. Updated Terms will be made available through the App or other appropriate channel, and notice/consent will be obtained where required by law.'
                        ),
                        SizedBox(height: 14.h),

                        // Section 14
                        _buildSectionTitle('14. Chit Agreement Prevails'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'IMPORTANT: These Terms govern only use of the mobile application. They do not replace, cancel or modify the customer\'s underlying chit agreement. Chit subscription, installments, auction/bidding, prize amount, discount/dividend, foreman\'s commission, security, default, surrender, termination and other chit rights and obligations remain governed by the applicable chit agreement and applicable law.'
                        ),
                        SizedBox(height: 14.h),

                        // Section 15
                        _buildSectionTitle('15. Governing Law, Support & Acceptance'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'These Terms are governed by applicable laws of India. Subject to applicable law and the underlying chit agreement, competent courts/authorities in Tamil Nadu, India will have jurisdiction.'
                        ),
                        SizedBox(height: 14.h),

                        // Customer Support
                        _buildSectionTitle('Customer Support:'),
                        SizedBox(height: 5.h),
                        _buildParagraph(
                          'Siva Saravana Chits (Private) Limited\n'
                          'No: 19, Parameswari Nagar, Nelikuppam, Opp to Siga College, Cuddalore District, Tamil Nadu - 607105.\n'
                          'Email: sivasaravanachits@gmail.com\n'
                          'Phone: 04142-261545',
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ),

                // 2. Fixed Sticky Footer (Figma: StickyFooter - Width: 360px, Hug 150px, Top-left/right radius: 22.15px, drop shadow)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: 14.77.h,
                      left: 18.46.w,
                      right: 18.46.w,
                      bottom: 22.h + bottomSafeArea,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22.15.r),
                        topRight: Radius.circular(22.15.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0x0D000000,
                          ), // 5% opacity black drop shadow
                          offset: Offset(0, -3.69.h),
                          blurRadius: 14.77.r,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Checkbox Section Row
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isAgreed = !_isAgreed;
                            });
                          },
                          borderRadius: BorderRadius.circular(6.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Small Checkbox Box (Figma: Green border & check icon when selected)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 18.r,
                                  height: 18.r,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: _isAgreed
                                          ? AppColors.primary
                                          : const Color(0xFFD1D5DB),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _isAgreed
                                      ? Icon(
                                          Icons.check,
                                          size: 14.r,
                                          color: AppColors.primary,
                                        )
                                      : null,
                                ),
                                SizedBox(width: 10.w),
                                // "I have read and agree to the Terms & Risk Disclosure" (Font: Inter, 12px, Regular 400, #000000)
                                Expanded(
                                  child: Text(
                                    'I have read and agree to the Terms & Risk Disclosure',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF000000),
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 18.h),

                        // Action Buttons Row (Disagree & Agree & Continue)
                        Row(
                          children: [
                            // Disagree Button
                            Expanded(
                              child: SizedBox(
                                height: 46.h,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                    ),
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF000000),
                                    side: const BorderSide(
                                      color: Color(0xFFE5E7EB),
                                      width: 1.2,
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Disagree',
                                      maxLines: 1,
                                      style: GoogleFonts.inter(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),

                            // Agree & Continue Button (Turns Green only when checkbox is selected)
                            Expanded(
                              child: SizedBox(
                                height: 46.h,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  decoration: BoxDecoration(
                                    color: _isAgreed
                                        ? AppColors.primary
                                        : const Color(0xFFE5E7EB),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isAgreed
                                        ? _onAgreeAndContinue
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      backgroundColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor:
                                          Colors.transparent,
                                      disabledForegroundColor: const Color(
                                        0xFF9CA3AF,
                                      ),
                                      shadowColor: Colors.transparent,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'Agree & Continue',
                                        maxLines: 1,
                                        softWrap: false,
                                        style: GoogleFonts.inter(
                                          fontSize: 13.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: _isAgreed
                                              ? Colors.white
                                              : const Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Figma Heading: Font: Inter, Weight: 600 (SemiBold), Size: 12px, Line height: 20px, Color: #000000
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF000000),
        height: 20 / 12,
        letterSpacing: 0,
      ),
    );
  }

  // Figma Body Text: Font: Inter, Weight: 400 (Regular), Size: 12px, Line height: 20px, Color: #000000
  Widget _buildParagraph(String content) {
    return Text(
      content,
      textAlign: TextAlign.justify,
      style: GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF000000),
        height: 20 / 12,
        letterSpacing: 0,
      ),
    );
  }

  // Figma Bullet points: Font: Inter, Weight: 400 (Regular), Size: 12px, Line height: 20px, Color: #000000
  Widget _buildBulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, left: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF000000),
                height: 20 / 12,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
