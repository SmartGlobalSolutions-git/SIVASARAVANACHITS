import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import '../../services/chit_scheme_api.dart';
import '../../services/payment_api.dart';
import '../../services/translation_service.dart';
import '../payment_sections/pending_history.dart';
import '../payment_sections/approval_history.dart';
import '../payment_sections/payment_method.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';

class AppColors {
  static const Color scaffoldBackground = Color(0xFFF3F3F5);
  static const Color primary = Color(0xFF0C8A4B);
  static const Color white = Colors.white;
  static const Color textDark = Colors.black87;
  static const Color textGrey = Colors.grey;
  static const Color textBody = Colors.black;
  static const Color textLightGrey = Colors.grey;
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color cardSubContainer = Color(0xFFF8FAFC);
  static const Color cardSubDivider = Color(0xFFE2E8F0);
  static const Color checkboxInactive = Colors.grey;
  static const Color activeGreenDot = Colors.greenAccent;
  static const Color unpricedBg = Color(0xFFFFF7E6);
  static const Color unpricedBorder = Colors.orangeAccent;
  static const Color unpricedText = Colors.orange;
  static const Color startCalBg = Color(0xFFE0F2FE);
  static const Color startCalIcon = Colors.blue;
  static const Color endCalBg = Color(0xFFF3E8FF);
  static const Color endCalIcon = Colors.purple;
  static const Color viewDetailsBlue = Color(0xFF1B3C73);
  static const Color cardBorder = Color(0xFFE2E8F0);
  static const Color primaryGradientEnd = Color(0xFF096b3a);
  static const Color waveAccent = Color(0xFF4ade80);
}

class PaymentScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final VoidCallback? onMenuTap;

  const PaymentScreen({Key? key, this.onBackToHome, this.onMenuTap})
    : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool isMyChitsOverview = true;
  bool isIndividualChit = true;
  bool _isLoading = true;
  List<dynamic> _individualChits = [];
  List<dynamic> _familyChits = [];
  List<bool> _selectedIndividualChits = [];
  List<bool> _selectedFamilyChits = [];
  bool _isHistoryLoading = false;
  List<dynamic> _historyPayments = [];

  @override
  void initState() {
    super.initState();
    _fetchPaymentChits();
  }

  Future<void> _fetchPaymentHistory() async {
    setState(() => _isHistoryLoading = true);
    final response = await PaymentApiService.fetchPaymentHistory();
    if (mounted) {
      if (response != null && response['payments'] is List) {
        setState(() {
          _historyPayments = List<dynamic>.from(response['payments']);
          _isHistoryLoading = false;
        });
      } else {
        setState(() {
          _historyPayments = [];
          _isHistoryLoading = false;
        });
      }
    }
  }

  Future<void> _fetchPaymentChits() async {
    setState(() => _isLoading = true);
    final response = await ChitSchemeApiService.fetchPaymentChits();
    if (mounted) {
      if (response != null) {
        final List<dynamic> ind = response['individual_chits'] is List
            ? List<dynamic>.from(response['individual_chits'])
            : [];
        final List<dynamic> fam = response['family_chits'] is List
            ? List<dynamic>.from(response['family_chits'])
            : [];
        setState(() {
          _individualChits = ind;
          _familyChits = fam;
          _selectedIndividualChits = List.generate(ind.length, (_) => true);
          _selectedFamilyChits = List.generate(fam.length, (_) => true);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    try {
      final formatter = NumberFormat('#,##,###');
      if (amount is int) return formatter.format(amount);
      if (amount is double) return formatter.format(amount);
      if (amount is String) return formatter.format(double.parse(amount));
    } catch (e) {
      return amount.toString();
    }
    return amount.toString();
  }

  double _calculateTotalAmount(List<dynamic> chits, List<bool> selected) {
    double total = 0;
    for (int i = 0; i < chits.length; i++) {
      if (i < selected.length && selected[i]) {
        final rb = chits[i]['running_balance'];
        if (rb != null) {
          total += double.tryParse(rb.toString()) ?? 0;
        }
      }
    }
    return total;
  }

  String _formatChitDates(dynamic chit) {
    final start = chit['start_date_display'] ?? chit['start_date'];
    final end = chit['end_date_display'] ?? chit['end_date'];
    if (start == null && end == null) return '-';
    if (start == null) return '-\n$end';
    if (end == null) return '$start\n-';
    return '$start -\n$end';
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
        backgroundColor: AppColors.scaffoldBackground,
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
            child: const Icon(Icons.menu, color: AppColors.textDark),
          ),
          titleSpacing: 0,
          surfaceTintColor: Colors.transparent,
          title: TrText(
            'Payment',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                // Tabs
                Container(
                  color: AppColors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isMyChitsOverview = true),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                              color: isMyChitsOverview
                                  ? const Color(0xFFE8F6ED)
                                  : AppColors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: isMyChitsOverview
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2.h,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: TrText(
                              'My Chits Overview',
                              style: TextStyle(
                                color: isMyChitsOverview
                                    ? AppColors.primary
                                    : AppColors.textGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => isMyChitsOverview = false);
                            if (_historyPayments.isEmpty) {
                              _fetchPaymentHistory();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                              color: !isMyChitsOverview
                                  ? const Color(0xFFE8F6ED)
                                  : AppColors.white,
                              border: Border(
                                bottom: BorderSide(
                                  color: !isMyChitsOverview
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  width: 2.h,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: TrText(
                              'Payment History',
                              style: TextStyle(
                                color: !isMyChitsOverview
                                    ? AppColors.primary
                                    : AppColors.textGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),

                // Buttons Individual / Family (Only show if My Chits Overview)
                if (isMyChitsOverview) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => isIndividualChit = true),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isIndividualChit
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(color: AppColors.primary),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TrText(
                                    'Individual Chit',
                                    style: TextStyle(
                                      color: isIndividualChit
                                          ? AppColors.white
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  if (_individualChits.isNotEmpty)
                                    Text(
                                      ' (${_individualChits.length})',
                                      style: TextStyle(
                                        color: isIndividualChit
                                            ? AppColors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => isIndividualChit = false),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: !isIndividualChit
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(color: AppColors.primary),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TrText(
                                    'Family Chit',
                                    style: TextStyle(
                                      color: !isIndividualChit
                                          ? AppColors.white
                                          : AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  if (_familyChits.isNotEmpty)
                                    Text(
                                      ' (${_familyChits.length})',
                                      style: TextStyle(
                                        color: !isIndividualChit
                                            ? AppColors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                ],

                // List
                Expanded(
                  child: !isMyChitsOverview
                      ? _buildPaymentHistoryList()
                      : _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _fetchPaymentChits,
                          child: isIndividualChit
                              ? (_individualChits.isEmpty
                                    ? Center(
                                        child: TrText(
                                          'No individual chits found.',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      )
                                    : ListView(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 5.h,
                                        ),
                                        children: [
                                          ...List.generate(
                                            _individualChits.length,
                                            (index) => Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 15.h,
                                              ),
                                              child: _buildIndividualChitCard(
                                                index,
                                                _individualChits[index],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          _buildPayBottomBar(
                                            _selectedIndividualChits
                                                .where((e) => e)
                                                .length,
                                            _calculateTotalAmount(
                                              _individualChits,
                                              _selectedIndividualChits,
                                            ),
                                          ),
                                        ],
                                      ))
                              : (_familyChits.isEmpty
                                    ? Center(
                                        child: TrText(
                                          'No family chits found.',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.textGrey,
                                          ),
                                        ),
                                      )
                                    : ListView(
                                        padding: EdgeInsets.only(
                                          top: 5.h,
                                          bottom: 20.h,
                                        ),
                                        children: [
                                          ...List.generate(
                                            _familyChits.length,
                                            (index) => _buildFamilyChitCard(
                                              index,
                                              _familyChits[index],
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                            ),
                                            child: _buildPayBottomBar(
                                              _selectedFamilyChits
                                                  .where((e) => e)
                                                  .length,
                                              _calculateTotalAmount(
                                                _familyChits,
                                                _selectedFamilyChits,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                        ),
                ),
              ],
            ),

            // Bot Icon
            const ChatboxWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildPayBottomBar(int selectedCount, double totalAmount) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrText(
                'Pay Selected',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                ' ( $selectedCount )',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: selectedCount == 0
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentMethodScreen(),
                      ),
                    );
                  },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: selectedCount == 0
                    ? AppColors.primary.withValues(alpha: 0.5)
                    : AppColors.primary,
                borderRadius: BorderRadius.circular(25.r),
              ),
              alignment: Alignment.center,
              child: totalAmount > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TrText(
                          'Pay',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ₹ ${_formatAmount(totalAmount)}',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : TrText(
                      'Pay Now',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndividualChitCard(int index, dynamic chit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndividualChits[index] = !_selectedIndividualChits[index];
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: _selectedIndividualChits[index]
                ? AppColors.primary
                : AppColors.cardBorder,
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: Stack(
            children: [
              // Top-right curved green decorative swoosh
              Positioned(
                top: 0,
                right: 0,
                width: 95.w,
                height: 55.h,
                child: const IgnorePointer(
                  child: CustomPaint(painter: CardTopRightWavePainter()),
                ),
              ),

              // Card Inner Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row: Avatar, Name, Group, Customer Badge, Checkbox
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar with group icon
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.groups,
                            color: AppColors.white,
                            size: 26.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),

                        // Customer Name & Group Detail
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (chit['chit_id'] != null && chit['chit_id'].toString().trim().isNotEmpty)
                                    ? "${(chit['name']?.toString() ?? '').isNotEmpty ? chit['name'] : (chit['chit_no'] ?? '')} - ${chit['chit_id']}"
                                    : (chit['name']?.toString() ?? ''),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  TrText(
                                    'Group Detail: ',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      chit['group_detail']?.toString() ??
                                          chit['group_name']?.toString() ??
                                          '',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.sp,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // "Customer" badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.2.w,
                            ),
                          ),
                          child: TrText(
                            chit['role']?.toString() ?? '-',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(width: 10.w),

                        // Rounded Checkbox
                        Container(
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: _selectedIndividualChits[index]
                                  ? AppColors.primary
                                  : AppColors.checkboxInactive,
                              width: 1.6.w,
                            ),
                            color: _selectedIndividualChits[index]
                                ? AppColors.primary
                                : AppColors.white,
                          ),
                          child: _selectedIndividualChits[index]
                              ? Icon(
                                  Icons.check,
                                  size: 15.sp,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),

                  // 3 Metrics Columns: Chit Value | Start - End Date | Running Balance
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 5.h,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Metric 1: Chit Value
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cardSubContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: AppColors.primary,
                                    size: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                TrText(
                                  'Chit Value',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  chit['chit_value_display']?.toString() ??
                                      _formatAmount(chit['chit_value']),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textBody,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1.w,
                            color: AppColors.dividerLight,
                            height: double.infinity,
                          ),

                          // Metric 2: Start - End Date
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cardSubContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_rounded,
                                    color: AppColors.primary,
                                    size: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                TrText(
                                  'Start - End Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  _formatChitDates(chit),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textBody,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Container(
                            width: 1.w,
                            color: AppColors.dividerLight,
                            height: double.infinity,
                          ),

                          // Metric 3: Running Balance
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 30.w,
                                  height: 30.w,
                                  decoration: const BoxDecoration(
                                    color: AppColors.cardSubContainer,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.currency_rupee_rounded,
                                    color: AppColors.primary,
                                    size: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                TrText(
                                  'Running Balance',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  chit['running_balance'] != null
                                      ? _formatAmount(chit['running_balance'])
                                      : '-',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppColors.textBody,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Bank Account & UPI ID Container
                  Container(
                    margin: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 10.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.cardSubContainer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        // Left: Bank Account
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.account_balance_rounded,
                                  color: AppColors.primary,
                                  size: 16.sp,
                                ),
                              ),
                              SizedBox(width: 7.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TrText(
                                      'A/C No:',
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      (chit['account_no'] != null &&
                                              chit['account_no']
                                                  .toString()
                                                  .trim()
                                                  .isNotEmpty)
                                          ? chit['account_no'].toString()
                                          : '-',
                                      style: TextStyle(
                                        color: AppColors.textBody,
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Center divider
                        Container(
                          height: 24.h,
                          width: 1.w,
                          color: AppColors.cardSubDivider,
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                        ),

                        // Right: UPI ID
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/upi.jpeg',
                                    height: 18.h,
                                    width: 18.w,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 7.w),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TrText(
                                      'UPI ID:',
                                      style: TextStyle(
                                        color: AppColors.textGrey,
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      (chit['upi_id'] != null &&
                                              chit['upi_id']
                                                  .toString()
                                                  .trim()
                                                  .isNotEmpty)
                                          ? chit['upi_id'].toString()
                                          : '-',
                                      style: TextStyle(
                                        color: AppColors.textBody,
                                        fontSize: 10.5.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyChitCard(int index, dynamic chit) {
    final String name = chit['name']?.toString() ?? '';
    final String chitId = chit['chit_id']?.toString() ?? '';
    final String displayName = (chitId.isNotEmpty && chitId != 'null')
        ? (name.isNotEmpty ? '$name - $chitId' : chitId)
        : name;
    final String groupDetail =
        chit['group_detail']?.toString() ??
        chit['group_name']?.toString() ??
        '';
    final String status = chit['status']?.toString() ?? 'Active';
    final String chitValue =
        chit['chit_value_display']?.toString() ??
        _formatAmount(chit['chit_value']);
    final String priceStatus = chit['prize_status']?.toString() ?? '-';
    final String startDate =
        chit['start_date_display']?.toString() ??
        chit['start_date']?.toString() ??
        '-';
    final String endDate =
        chit['end_date_display']?.toString() ??
        chit['end_date']?.toString() ??
        '-';

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFamilyChits[index] = !_selectedFamilyChits[index];
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: _selectedFamilyChits[index]
                ? AppColors.primary
                : const Color(0x44FEF3C7),
            width: 0.8.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A000000),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: -1,
            ),
            BoxShadow(
              color: const Color(0x0F000000),
              offset: const Offset(0, 8),
              blurRadius: 24,
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Green Header Bar: Avatar, Member Name, Group Badge, Active Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                color: AppColors.primary,
                child: Row(
                  children: [
                    // White circular avatar with person icon
                    Container(
                      width: 28.w,
                      height: 28.w,
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/payment_profile.png',
                        width: 10.w,
                        height: 10.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Name & Group badge in Expanded
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6.w),

                          // Group badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x44FFFFFF),
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Text(
                              groupDetail,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 6.w),

                    // Active status badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x55FFFFFF),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: const Color(0xFF00A859),
                            size: 8.w,
                          ),
                          SizedBox(width: 4.w),
                          TrText(
                            status,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Checkbox
                    Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: AppColors.white,
                          width: 1.6.w,
                        ),
                        color: _selectedFamilyChits[index]
                            ? AppColors.white
                            : Colors.transparent,
                      ),
                      child: _selectedFamilyChits[index]
                          ? Icon(
                              Icons.check,
                              size: 15.sp,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ],
                ),
              ),

              // Card Body (White section)
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Chit Value & Unpriced Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TrText(
                              'CHIT VALUE',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              '₹ $chitValue',
                              style: TextStyle(
                                color: AppColors.textBody,
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // Unpriced Pill Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF2E8),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Color(0xFFFFE0CC),
                              width: 1.0.w,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                color: Color(0xFFE05A17),
                                size: 13.sp,
                              ),
                              SizedBox(width: 4.w),
                              TrText(
                                priceStatus,
                                style: TextStyle(
                                  color: Color(0xFFE05A17),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10.h),

                    // Row 2: Start Date & End Date Container Box
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFF3F4F6),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Left: Start Date
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(7.r),
                                    border: Border.all(
                                      color: Color(0xFFDBEAFE),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFF0D6EFD),
                                    size: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TrText(
                                        'START',
                                        style: TextStyle(
                                          color: AppColors.textLightGrey,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        startDate,
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Container(
                            height: 24.h,
                            width: 1.w,
                            color: const Color(0xFFE5E7EB),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                          ),

                          // Right: End Date
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 28.w,
                                  height: 28.w,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFAF5FF),
                                    borderRadius: BorderRadius.circular(7.r),
                                    border: Border.all(
                                      color: Color(0xFFF3E8FF),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Color(0xFFA855F7),
                                    size: 14.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TrText(
                                        'END',
                                        style: TextStyle(
                                          color: AppColors.textLightGrey,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        endDate,
                                        style: TextStyle(
                                          color: AppColors.textDark,
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryList() {
    if (_isHistoryLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: _fetchPaymentHistory,
      child: _historyPayments.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 120.h),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 50.sp,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 10.h),
                      TrText(
                        'No payment history found',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              itemCount: _historyPayments.length,
              itemBuilder: (context, index) {
                final payment = _historyPayments[index];
                return _buildHistoryListItem(index, payment);
              },
            ),
    );
  }

  Widget _buildHistoryListItem(int index, dynamic payment) {
    final String currentMonth = payment['month_label']?.toString() ?? '';
    final bool showMonthDivider = currentMonth.isNotEmpty &&
        (index == 0 ||
            _historyPayments[index - 1]['month_label']?.toString() !=
                currentMonth);

    final chitIdVal = payment['chit_id']?.toString() ??
        payment['chit_no']?.toString() ??
        '';
    final String chitId = 'Chit / $chitIdVal';

    final groupName = payment['group_name']?.toString() ?? '';
    final groupDetail = payment['group_detail']?.toString() ?? '';
    String groupDisplay = 'Group Name / ';
    if (groupName.isNotEmpty && groupDetail.isNotEmpty) {
      groupDisplay += '$groupName / $groupDetail';
    } else if (groupName.isNotEmpty) {
      groupDisplay += groupName;
    } else if (groupDetail.isNotEmpty) {
      groupDisplay += groupDetail;
    } else {
      groupDisplay += '-';
    }

    final String dateDisplay = (payment['datetime_display'] != null &&
            payment['datetime_display'].toString().trim().isNotEmpty)
        ? payment['datetime_display'].toString()
        : '${payment['date'] ?? ''} ${payment['time'] ?? ''}'.trim();

    final String status = payment['status']?.toString() ?? 'Approved';
    final bool isPending = status.toLowerCase() == 'pending';
    final String amountDisplay =
        '₹${payment['amount_display'] ?? payment['amount'] ?? '0'}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showMonthDivider) ...[
          if (index > 0) SizedBox(height: 15.h),
          Center(
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade300)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TrText(
                    currentMonth,
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade300)),
              ],
            ),
          ),
          SizedBox(height: 15.h),
        ],
        _buildHistoryCard(
          payment: payment,
          chitId: chitId,
          groupName: groupDisplay,
          date: dateDisplay,
          status: status,
          amount: amountDisplay,
          isPending: isPending,
        ),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildHistoryCard({
    required dynamic payment,
    required String chitId,
    required String groupName,
    required String date,
    required String status,
    required String amount,
    required bool isPending,
  }) {
    return GestureDetector(
      onTap: () {
        if (isPending) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PendingHistoryScreen(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApprovalHistoryScreen(
                paymentData: payment is Map<String, dynamic>
                    ? payment
                    : Map<String, dynamic>.from(payment as Map),
              ),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6ED),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: const Color(0xFF0C8A4B),
                size: 20.sp,
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chitId,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    groupName,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    date,
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isPending ? Colors.orange.shade50 : Colors.white,
                    border: Border.all(
                      color: isPending
                          ? Colors.orange.shade200
                          : const Color(0xFF1B3C73),
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      if (isPending)
                        Container(
                          margin: EdgeInsets.only(right: 4.w),
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        )
                      else
                        Padding(
                          padding: EdgeInsets.only(right: 4.w),
                          child: Icon(
                            Icons.check,
                            color: const Color(0xFF1B3C73),
                            size: 12.sp,
                          ),
                        ),
                      TrText(
                        status,
                        style: TextStyle(
                          color: isPending
                              ? Colors.orange
                              : const Color(0xFF1B3C73),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0C8A4B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardTopRightWavePainter extends CustomPainter {
  const CardTopRightWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Main emerald wave
    final path1 = Path()
      ..moveTo(w * 0.40, 0)
      ..cubicTo(w * 0.65, h * 0.10, w * 0.80, h * 0.45, w, h * 0.85)
      ..lineTo(w, 0)
      ..close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.primary, AppColors.primaryGradientEnd],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path1, paint1);

    // Mint wave accent highlight
    final path2 = Path()
      ..moveTo(w * 0.28, 0)
      ..cubicTo(w * 0.58, h * 0.15, w * 0.76, h * 0.60, w, h * 1.0)
      ..lineTo(w, h * 0.85)
      ..cubicTo(w * 0.80, h * 0.45, w * 0.65, h * 0.10, w * 0.40, 0)
      ..close();

    final paint2 = Paint()..color = AppColors.waveAccent.withValues(alpha: 0.65);

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
