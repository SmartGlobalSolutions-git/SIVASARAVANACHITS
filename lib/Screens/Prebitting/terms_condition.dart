import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScreenBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Terms & Condition',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
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
    );
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
          onPressed: () => _showOtpBottomSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: kAcceptButtonBg,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.r),
            ),
          ),
          child: Text(
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

  void _showOtpBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const OtpBottomSheet(),
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
// OTP BOTTOM SHEET
// ----------------------------------------------------------------------
class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet({super.key});

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 30;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.trim().isNotEmpty);

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onConfirm() {
    if (!_isComplete) return;
    Navigator.pop(context); // close the bottom sheet.
    _showVerificationSuccessDialog(context);
  }

  void _showVerificationSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const VerificationSuccessDialog(),
    );
  }

  String get _timerLabel {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Push the sheet up above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Grabber handle.
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'OTP Verification',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 18.sp,
                height: 1.0,
                color: kOtpHeaderColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enter the 6-digit code sent to +91 98XXX XXXXX',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.0,
                color: kOtpSubtitleColor,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => _buildDigitBox(i)),
            ),
            SizedBox(height: 16.h),
            _secondsLeft > 0
                ? Text(
              "Didn't receive the code? Resend in $_timerLabel",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: Colors.black54,
              ),
            )
                : GestureDetector(
              onTap: _startResendTimer,
              child: Text(
                'Resend code',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                  color: kAcceptButtonBg,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: 329,
              height: 50,
              child: ElevatedButton(
                onPressed: _isComplete ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAcceptButtonBg,
                  disabledBackgroundColor: kAcceptButtonBg.withValues(alpha: 0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.35.r),
                  ),
                ),
                child: Text(
                  'Confirm',
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

  Widget _buildDigitBox(int index) {
    final bool isActive = _focusNodes[index].hasFocus ||
        (_controllers[index].text.isEmpty &&
            index == _controllers.indexWhere((c) => c.text.isEmpty));
    return SizedBox(
      width: 44.11.w,
      height: 51.46.h,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: kOtpBoxBorderInactive, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: isActive ? kOtpBoxBorderActive : kOtpBoxBorderInactive,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: kOtpBoxBorderActive, width: 2),
          ),
        ),
        onChanged: (v) => _onDigitChanged(index, v),
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
              'Verification Successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your account has been successfully\nverified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 10.46.sp,
                color: Color(0xff414752),
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