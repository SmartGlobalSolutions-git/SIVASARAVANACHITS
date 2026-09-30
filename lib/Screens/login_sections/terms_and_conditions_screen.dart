import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/app_colors.dart';
import '../main_wrapper.dart';
import '../first_time_main_wrapper.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final bool isNewUser;

  const TermsAndConditionsScreen({
    super.key,
    this.isNewUser = false,
  });

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
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
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 17.w,
                      right: 17.w,
                      top: 10.h,
                      bottom: 165.h, // Buffer so sticky bottom footer does not cover text
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section 1
                        _buildSectionTitle('1. Acceptance of Terms'),

                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'By using the application, you confirm that you have read, understood, and agreed to these Terms & Conditions and the applicable Privacy Policy. If you do not agree with these Terms, you should discontinue use of the application.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 2
                  _buildSectionTitle('2. Eligibility'),
                  SizedBox(height: 3.h),
                  _buildParagraph('Users must:'),
                  _buildBulletItem('Be legally eligible to use the services offered through the application.'),
                  _buildBulletItem('Provide accurate and valid registration information.'),
                  _buildBulletItem('Complete identity/KYC verification when required.'),
                  _buildBulletItem('Use the application only for lawful purposes.'),
                  _buildBulletItem('Comply with applicable rules, agreements, and regulatory requirements.'),
                  SizedBox(height: 14.h),

                  // Section 3
                  _buildSectionTitle('3. Account Registration'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Users may be required to register using a valid mobile number and other requested information.\n'
                    'You are responsible for maintaining the confidentiality and security of your account, OTPs, passwords, and device access.\n'
                    'You must notify the company immediately of any unauthorized access to your account.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 4
                  _buildSectionTitle('4. Chit Scheme Participation'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Participation in chit schemes is subject to the Chit Funds Act, 1982, applicable state chit fund rules, and the specific terms of the chit agreement.\n'
                    'Each chit group has a defined duration, total value, number of members, and monthly subscription amount.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 5
                  _buildSectionTitle('5. Monthly Subscriptions & Payments'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Members must pay their monthly subscription instalments on or before the due date specified for each chit cycle.\n'
                    'Payment methods accepted include digital payments, UPI, net banking, debit cards, and authorized offline collection channels.\n'
                    'Any failure to pay instalments on time may result in penalty charges, forfeiture of dividend benefits, or auction ineligibility.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 6
                  _buildSectionTitle('6. Bidding and Auction Process'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Prize auctions are conducted periodically in accordance with regulatory guidelines and group rules.\n'
                    'Only eligible non-prized members who have cleared all previous instalments are entitled to participate in the bidding process.\n'
                    'The maximum discount permitted in any auction is governed by the Chit Funds Act and state regulations.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 7
                  _buildSectionTitle('7. Prize Money Disbursement'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Prize money will be disbursed to the successful bidder after satisfactory completion of security documentation and guarantor verification.\n'
                    'The company reserves the right to evaluate and approve surety/security provided by the prized subscriber prior to disbursement.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 8
                  _buildSectionTitle('8. Dividend Distribution'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Dividends earned from chit auctions are distributed among eligible members in accordance with statutory rules and credited against subsequent instalments.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 9
                  _buildSectionTitle('9. Default and Removal'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'In the event of continuous default in payment of subscriptions, the company reserves the right to issue notice, initiate recovery proceedings, and replace defaulting members in accordance with the Chit Funds Act.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 10
                  _buildSectionTitle('10. Security and Guarantors'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Prized subscribers are required to furnish adequate security (such as personal sureties, property documents, or bank guarantees) to ensure future instalment payments.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 11
                  _buildSectionTitle('11. Charges, Fees and Commission'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'The company charges a foreman\'s commission as permitted under the Chit Funds Act, along with applicable taxes, statutory levies, and documentation fees.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 12
                  _buildSectionTitle('12. KYC & AML Compliance'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Subscribers must complete Know Your Customer (KYC) verification by submitting valid government identity and address proofs as mandated by regulatory authorities.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 13
                  _buildSectionTitle('13. User Obligations & Conduct'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Users agree not to use the application for fraudulent activities, money laundering, unauthorized financial transactions, or system abuse.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 14
                  _buildSectionTitle('14. Intellectual Property Rights'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'All content, logos, trademarks, designs, UI elements, and software in this application are the intellectual property of Siva Saravana Chits (P) Ltd and protected by law.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 15
                  _buildSectionTitle('15. Privacy and Data Security'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'Your personal and financial data is handled in accordance with our Privacy Policy. We employ industry-standard encryption and security measures to protect your information.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 16
                  _buildSectionTitle('16. Service Availability & Modifications'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'We strive to ensure uninterrupted service availability; however, maintenance, updates, or technical issues may temporarily affect access. We reserve the right to modify services with prior notice.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 17
                  _buildSectionTitle('17. Limitation of Liability'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'To the maximum extent permitted by law, Siva Saravana Chits (P) Ltd shall not be liable for indirect, incidental, or consequential damages arising from app usage or network interruptions.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 18
                  _buildSectionTitle('18. Indemnification'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'You agree to indemnify and hold harmless Siva Saravana Chits (P) Ltd and its officers against any claims, losses, or expenses resulting from your violation of these terms or misuse of the service.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 19 (Changes to These Terms matching exact Figma wording)
                  _buildSectionTitle('19. Changes to These Terms'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'We may revise these Terms & Conditions when necessary due to changes in services, policies, technology, or applicable requirements.\n'
                    'Updated Terms will be made available through the application or another appropriate channel. Continued use after an update may constitute acceptance where permitted by applicable law.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 20
                  _buildSectionTitle('20. Governing Law and Dispute Resolution'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'These Terms are governed by the laws of India and applicable regulatory requirements.\n'
                    'Any dispute will be handled in accordance with the applicable agreement, statutory dispute-resolution mechanisms, and jurisdiction requirements.',
                  ),
                  SizedBox(height: 14.h),

                  // Section 21
                  _buildSectionTitle('21. Customer Support & Grievances'),
                  SizedBox(height: 3.h),
                  _buildParagraph(
                    'For questions, payment issues, account corrections, complaints, or other support:\n'
                    'Siva Saravana Chits (P) Ltd\n'
                    'Registered Office: [Enter Registered Office Address]\n'
                    'Phone: [Enter Official Contact Number]\n'
                    'Email: [Enter Official Support Email]',
                  ),
                  SizedBox(height: 20.h),
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
                    color: const Color(0x0D000000), // 5% opacity black drop shadow
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
                              padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                              onPressed: _isAgreed ? _onAgreeAndContinue : null,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.transparent,
                                disabledForegroundColor: const Color(0xFF9CA3AF),
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
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
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF000000),
              height: 20 / 12,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.justify,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
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
