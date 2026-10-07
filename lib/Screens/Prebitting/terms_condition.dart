import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../services/prebid_api.dart';
import '../Home_Sections/drawers_screen.dart';

const Color kScreenBg = Color(0xFFF7F7F7);
const Color kSectionCardBg = Color(0xFFFFFFFF);
const Color kSectionCardBorder = Color(0xFFE2E2E2);
const Color kSectionNumberColor = Color(0xFF018F46);
const Color kSectionHeadingColor = Color(0xFF1A1C1C);
const Color kSectionBodyColor = Color(0xFF4D4732);
const Color kFooterBorder = Color(0xFFE2E2E2);
const Color kAcceptButtonBg = Color(0xFF018F46);
const Color kOtpHeaderColor = Color(0xFF1B1C1C);
const Color kOtpSubtitleColor = Color(0xFF414752);
const Color kOtpBoxBorderInactive = Color(0xFFD0D0D0);
const Color kOtpBoxBorderActive = Color(0xFF018F46);

// ----------------------------------------------------------------------
// DATA — the 4 Terms & Conditions sections.
// ----------------------------------------------------------------------
class _TermsSectionData {
  final String number;
  final String title;
  final List<String> paragraphs;
  const _TermsSectionData(this.number, this.title, this.paragraphs);
}

const List<_TermsSectionData> _sections = [
  _TermsSectionData('01.', 'Eligibility', [
    'Participation in the bidding process is restricted to active members of the specific Chit Fund group who have successfully completed all requisite KYC (Know Your Customer) and AML (Anti-Money Laundering) verifications as mandated by regional financial regulatory authorities.',
    'Members must maintain an account in good standing, free of any ongoing disputes, unresolved defaults, or delayed subscription payments from previous cycles. Failure to meet these criteria will result in immediate disqualification from the current auction.',
  ]),
  _TermsSectionData('02.', 'Bidding Process', [
    'The auction will commence at the predetermined date and time specified in the group schedule. Bids must be placed incrementally, adhering to the minimum step value established for this specific fund tier.',
    "The maximum bid limit (discount) is capped at the percentage agreed upon during the group's formation (typically 30-40% of the total chit value). Bids exceeding this cap will be automatically rejected by the ledger system. In the event of a tie at the maximum discount, the successful bidder will be determined via a transparent, cryptographically secure random draw.",
  ]),
  _TermsSectionData('03.', 'Dividend Calculations', [
    "The total discount offered by the successful bidder, minus the foreman's commission (standardly set at 5% of the total chit value), constitutes the divisible dividend pool for the current cycle.",
    'This dividend pool will be distributed equally among all non-prized and prized subscribers of the group, effectively reducing their subscription obligation for the subsequent month. Dividends are credited to subscriber accounts within 24 hours of auction closure.',
  ]),
  _TermsSectionData('04.', 'Cancellations & Modifications', [
    'Once a bid is officially submitted and recorded on the ledger during an active auction window, it is considered binding and irrevocable. Bidders cannot withdraw or lower their bid amounts under any circumstances.',
    'If a successful bidder fails to provide the necessary collaterals or guarantors within the stipulated 7-day period post-auction, the bid will be voided. A penalty equivalent to 5% of the chit value will be levied against the defaulting member, and a re-auction will be scheduled.',
  ]),
];

// ----------------------------------------------------------------------
// SCREEN
// ----------------------------------------------------------------------
class TermsAndConditionsScreen extends StatefulWidget {
  final String chitId;
  final String amount;
  final String groupName;
  final String bidderName;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;

  const TermsAndConditionsScreen({
    super.key,
    required this.chitId,
    required this.amount,
    required this.groupName,
    required this.bidderName,
    this.onBackTap,
    this.onMenuTap,
  });

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = false;

  void _submitPrebid() async {
    setState(() => _isLoading = true);
    final response = await PrebidApiService.insertPrebid(widget.chitId, widget.amount, widget.groupName, widget.bidderName);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response != null && response['error'] == false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const VerificationSuccessDialog(),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response?['message']?.toString() ??
            response?['error_msg']?.toString() ??
            'Something went wrong',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: kScreenBg,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          titleSpacing: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.black, size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        title: Text(
          'Terms & Condition',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
              itemCount: _sections.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) => _TermsSectionCard(data: _sections[index]),
            ),
          ),
          _buildFixedFooter(context),
        ],
      ),
    ));
  }

  Widget _buildFixedFooter(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kFooterBorder, width: 0.92)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 11.08,
            offset: const Offset(0, -3.69),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitPrebid,
          style: ElevatedButton.styleFrom(
            backgroundColor: kAcceptButtonBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.r),
            ),
          ),
          child: _isLoading 
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Accept and Continue',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// One numbered section card.
// ----------------------------------------------------------------------
class _TermsSectionCard extends StatelessWidget {
  final _TermsSectionData data;
  const _TermsSectionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(21.92.r),
      decoration: BoxDecoration(
        color: kSectionCardBg,
        borderRadius: BorderRadius.circular(10.96.r),
        border: Border.all(color: kSectionCardBorder, width: 0.91),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.number,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontWeight: FontWeight.w700,
                  fontSize: 21.92.sp,
                  height: 29.23 / 21.92,
                  letterSpacing: -0.44,
                  color: kSectionNumberColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.27.sp,
                    height: 25.58 / 18.27,
                    color: kSectionHeadingColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.96.h),
          ...data.paragraphs.map(
                (p) => Padding(
              padding: EdgeInsets.only(bottom: 10.96.h),
              child: Text(
                p,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.61.sp,
                  color: kSectionBodyColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// VERIFICATION SUCCESSFUL — centered popup dialog.
// ----------------------------------------------------------------------
class VerificationSuccessDialog extends StatelessWidget {
  const VerificationSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/prebitting/success.png',
              width: 60.w,
              height: 65.h,
            ),
            SizedBox(height: 5.h),
            Text(
              'Prebid Successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 41.83.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAcceptButtonBg,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.98.r),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}