import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// The Terms & Conditions screen displaying user agreements, digital service rules,
/// payment terms, auction rules, and company policies.
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          'Terms & Condition',
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Updated & Effective From
                  Text(
                    'Last Updated [Date]',
                    style: bodyStyle,
                  ),
                  Text(
                    'Effective From [Date]',
                    style: bodyStyle,
                  ),
                  SizedBox(height: 14.h),

                  // Introduction paragraph
                  Text(
                    'By registering, accessing or using the App, you agree to these Terms & Conditions. These Terms govern use of the App as a digital service channel.',
                    style: bodyStyle,
                  ),
                  SizedBox(height: 10.h),

                  // 1. Eligibility, Registration & KYC
                  _buildSection(
                    title: '1. Eligibility, Registration & KYC',
                    content:
                        'The App is for eligible customers of the Company. You must provide accurate, complete and current information and complete applicable KYC/verification requirements. Registration or App access does not by itself create or guarantee membership in any chit group.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 2. Account & OTP Security
                  _buildSection(
                    title: '2. Account & OTP Security',
                    content:
                        'You are responsible for keeping your login credentials and OTPs confidential and for securing your device. Do not share OTPs, UPI PINs, card PINs or banking passwords. Report suspected unauthorized access to the Company promptly.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 3. Chit Information & Payment Obligations
                  _buildSection(
                    title: '3. Chit Information & Payment Obligations',
                    content:
                        'The App may display chit group details, installments, due dates, outstanding amounts, payment history, auction information, prize/bid information, discount/dividend details, receipts and statements. You remain responsible for paying installments and other applicable amounts on time in accordance with your chit agreement. App unavailability or non-receipt of a reminder does not by itself extend a due date.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 4. Online Payments, Failed Transactions & Refunds
                  _buildSection(
                    title: '4. Online Payments, Failed Transactions & Refunds',
                    content:
                        'Payments may be made through available digital methods and processed by third-party banks/payment providers. Where a convenience fee, payment gateway charge, processing fee or applicable tax is levied for using an online payment facility, the applicable charge shall be borne by the customer and will be displayed before payment confirmation, where applicable. Such charge is separate from the chit installment amount. A payment is treated as credited only after successful processing and reconciliation in the Company\'s records. If a transaction is pending, failed, duplicated, debited but not reflected, reversed or otherwise disputed, contact the Company with the transaction reference. Any refund, reversal or adjustment that is applicable will be processed after verification/reconciliation and subject to the applicable payment process, chit agreement and law.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 5. Fees, Charges & Penalties
                  _buildSection(
                    title: '5. Fees, Charges & Penalties',
                    content:
                        'Installments, charges, penalties, taxes or other amounts, where applicable, will be governed by the customer\'s chit agreement, applicable schedule/Company records and law. Nothing in these App Terms creates a new charge merely by mentioning a category of charge.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 6. Auction / Bidding Through the App
                  _buildSection(
                    title: '6. Auction / Bidding Through the App',
                    content:
                        'Where auction or bidding functionality is enabled, participation is limited to customers eligible under the applicable chit agreement and Company records. Auction timing, bidding method, permissible discount/bid limits, eligibility, successful bidder selection, security/collateral requirements, prize payment and dividend/discount treatment will be governed by the applicable chit agreement, Company procedures and applicable law.\n'
                        'A bid submitted through the App may be treated as binding once validly recorded in accordance with the applicable auction rules. The Company may reject an invalid, unauthorized, late or non-compliant bid. If there is any conflict between an App display and the applicable chit agreement or legally maintained Company records, the chit agreement and applicable law will prevail, subject to correction of genuine errors.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 7. Digital Receipts, Records & Notifications
                  _buildSection(
                    title: '7. Digital Receipts, Records & Notifications',
                    content:
                        'The App may provide electronic receipts, statements, payment confirmations and other records. The Company may send service communications through App notifications, SMS, email, WhatsApp or other permitted channels, where implemented. You should keep your registered contact information current and promptly report any material discrepancy in your account.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 8. App Availability
                  _buildSection(
                    title: '8. App Availability',
                    content:
                        'We will make reasonable efforts to keep the App available, but temporary interruptions may occur due to maintenance, updates, network issues, banking/payment-provider failures, security events or circumstances beyond reasonable control. We do not guarantee uninterrupted or error-free operation.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 9. Prohibited Use
                  _buildSection(
                    title: '9. Prohibited Use',
                    content:
                        'You must not use the App unlawfully; provide false or misleading information; access another person\'s account without authorization; manipulate bidding or payment functions; bypass security; introduce malicious code; misuse payment facilities; or copy, modify, reverse engineer or interfere with the App except where legally permitted.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 10. Privacy & Intellectual Property
                  _buildSection(
                    title: '10. Privacy & Intellectual Property',
                    content:
                        'Personal information is handled in accordance with the Company\'s Privacy Policy. The App, software, design, content, logos and other intellectual property are owned by or licensed to the Company. Your right to use the App is limited to legitimate customer-service purposes.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 11. Suspension / Restriction
                  _buildSection(
                    title: '11. Suspension / Restriction',
                    content:
                        'The Company may suspend or restrict App access where reasonably necessary for security, verification, maintenance, suspected fraud/misuse, legal requirements or violation of these Terms. Suspension of App access does not automatically cancel or terminate the underlying chit subscription or payment obligations.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 12. Limitation of Liability
                  _buildSection(
                    title: '12. Limitation of Liability',
                    content:
                        'To the extent permitted by law, the Company is not responsible for loss caused solely by third-party payment/network failures, device problems, customer misuse or circumstances beyond its reasonable control. Nothing in these Terms excludes any liability or customer right that cannot legally be excluded or limited.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 13. Changes to Terms
                  _buildSection(
                    title: '13. Changes to Terms',
                    content:
                        'The Company may update these Terms to reflect changes in the App, services, security, technology or applicable law. Updated Terms will be made available through the App or other appropriate channel, and notice/consent will be obtained where required by law.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 14. Chit Agreement Prevails
                  _buildSection(
                    title: '14. Chit Agreement Prevails',
                    content:
                        'IMPORTANT: These Terms govern only use of the mobile application. They do not replace, cancel or modify the customer\'s underlying chit agreement. Chit subscription, installments, auction/bidding, prize amount, discount/dividend, foreman\'s commission, security, default, surrender, termination and other chit rights and obligations remain governed by the applicable chit agreement and applicable law.',
                    titleStyle: titleStyle,
                    bodyStyle: bodyStyle,
                  ),

                  // 15. Governing Law, Support & Acceptance
                  _buildSection(
                    title: '15. Governing Law, Support & Acceptance',
                    content:
                        'These Terms are governed by applicable laws of India. Subject to applicable law and the underlying chit agreement, competent courts/authorities in Tamil Nadu, India will have jurisdiction.\n\n'
                        'Customer Support:\n'
                        'SIVASARAVANA CHIT FUNDS PRIVATE LIMITED\n'
                        'No. 16, Chennimalai Nager, Gandhipudur, Uppilipalayam,\n'
                        'Coimbatore – 641015, Tamil Nadu, India.\n'
                        'Email: [Email Address]    Phone: [Phone Number]\n\n'
                        'Acceptance: By clicking “Accept and Continue” / “I Agree”, or by continuing to use the App, you confirm that you have read, understood and agreed to these Terms & Conditions and acknowledge the Privacy Policy.',
                    titleStyle: titleStyle,
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
          Text(
            title,
            style: titleStyle,
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: bodyStyle,
          ),
        ],
      ),
    );
  }
}
