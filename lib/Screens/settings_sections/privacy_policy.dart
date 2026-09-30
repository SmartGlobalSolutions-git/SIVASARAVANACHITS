import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// The Privacy Policy screen displaying legal policies, data collection,
/// usage guidelines, and company contact information.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Style specifications per user requirements
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
          'Privacy policy',
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
                'Last Updated [07/09/26]',
                style: bodyStyle,
              ),
                  Text(
                    'Effective From [10/09/26]',
                    style: bodyStyle,
                  ),
                  SizedBox(height: 14.h),

                  // Introduction paragraph
                  Text(
                    'We respect your privacy and are committed to protecting your personal information when you use our customer mobile application (“App”).',
                    style: bodyStyle,
                  ),
                  SizedBox(height: 10.h),

              // 1. Information We Collect
              _buildSection(
                title: '1. Information We Collect',
                content:
                    'We may collect information necessary to provide chit fund and App services, including:\n'
                    'Name, mobile number, email address, residential/correspondence address and customer/member details. '
                    'PAN, Aadhaar-related information, photograph, address/identity proof and other KYC information, where required and lawfully permitted. '
                    'Nominee and bank account details, where applicable. Chit group, subscription, installment, auction, payment, receipt and transaction details. '
                    'Device, login and technical information needed for App security, troubleshooting and performance.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 2. How We Use Your Information
              _buildSection(
                title: '2. How We Use Your Information',
                content:
                    'Register, verify and maintain your customer profile. '
                    'Display chit group, installment, due, auction, payment and account information. '
                    'Process and reconcile payments and generate receipts/statements. '
                    'Send due reminders, payment confirmations, auction/service notifications and important communications. '
                    'Provide customer support, handle requests/complaints, prevent misuse or fraud, and meet applicable legal, audit and regulatory requirements.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 3. Payments & Service Providers
              _buildSection(
                title: '3. Payments & Service Providers',
                content:
                    'Payments may be made through UPI, debit/credit cards, net banking or other available digital methods and may be processed by banks, payment gateways or other authorized payment service providers. '
                    'We do not ask you to disclose your UPI PIN, card PIN or banking password to the Company. '
                    'Necessary information may also be shared with authorized technology, communication, audit and professional service providers for providing the service.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 4. Data Sharing
              _buildSection(
                title: '4. Data Sharing',
                content:
                    'We do not sell customer personal information as a commercial commodity. '
                    'We may share necessary information with authorized employees, banks/payment providers, technology or communication service providers, auditors/professional advisers, and government, regulatory, judicial or law-enforcement authorities where required or permitted by law.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 5. Security & Retention
              _buildSection(
                title: '5. Security & Retention',
                content:
                    'We use reasonable technical and organizational safeguards to protect personal information against unauthorized access, misuse, loss or disclosure. '
                    'No digital system can be guaranteed to be completely secure. '
                    'Information is retained only for as long as reasonably necessary for service, chit records, accounting/audit, dispute resolution and applicable legal or regulatory requirements.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 6. App Permissions & Communications
              _buildSection(
                title: '6. App Permissions & Communications',
                content:
                    'Depending on the App features, permissions such as notifications, camera, files/storage or other device access may be requested where required. '
                    'You can manage device permissions through your device settings. '
                    'We may send essential service communications through the App, SMS, email, WhatsApp or other permitted channels, where implemented.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 7. Your Rights
              _buildSection(
                title: '7. Your Rights',
                content:
                    'Subject to applicable law, you may request access to applicable information about processing, correction or updating of your personal information, deletion where legally permissible, or raise a privacy grievance. '
                    'Certain records may need to be retained where required by law or for legitimate contractual, accounting, audit or dispute purposes.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 8. Children's Privacy
              _buildSection(
                title: '8. Children\'s Privacy',
                content:
                    'The App is intended for customers legally eligible to use the relevant services. '
                    'We do not knowingly collect children\'s personal information except where legally permitted and appropriately handled.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 9. Changes to this Policy
              _buildSection(
                title: '9. Changes to this Policy',
                content:
                    'We may update this Privacy Policy when our App, services, technology or legal requirements change. '
                    'The latest version will be made available through the App and/or our official website.',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 10. Contact & Grievance
              _buildSection(
                title: '10. Contact & Grievance',
                content:
                    'SIVASARAVANA CHIT FUNDS PRIVATE LIMITED\n'
                    'No. 16, Chennimalai Nager, Gandhipudur,Uppilipalayam,\n'
                    'Coimbatore – 641015, Tamil Nadu, India.\n'
                    'Email: [Email Address]    Phone: [Phone Number]\n'
                    'Grievance Officer: [Grievance Officer Name]    Grievance Email: [Grievance Email Address]',
                titleStyle: titleStyle,
                bodyStyle: bodyStyle,
              ),

              // 11. Applicable Law & Chit Agreement
              _buildSection(
                title: '11. Applicable Law & Chit Agreement',
                content:
                    'This Privacy Policy is subject to applicable laws of India and relevant requirements applicable to chit fund operations in Tamil Nadu. '
                    'This Policy governs privacy relating to the App and does not replace or modify the customer\'s underlying chit agreement.',
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
