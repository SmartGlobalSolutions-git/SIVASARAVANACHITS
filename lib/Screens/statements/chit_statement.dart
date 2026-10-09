import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/Home_Sections/need_help_screen.dart';
import 'package:siva_saravana/Screens/Home_Sections/notification_screen.dart';
import 'package:siva_saravana/constants/app_colors.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';
import 'package:intl/intl.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/utils/pdf_generator.dart';
import '../Home_Sections/drawers_screen.dart';

class ChitStatementScreen extends StatefulWidget {
  final dynamic chitId;
  final String? dateRange;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;

  const ChitStatementScreen({
    super.key,
    this.chitId,
    this.dateRange,
    this.onBackTap,
    this.onMenuTap,
  });

  @override
  State<ChitStatementScreen> createState() => _ChitStatementScreenState();
}

class _ChitStatementScreenState extends State<ChitStatementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = true;
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchStatement();
  }

  Future<void> _fetchStatement() async {
    if (widget.chitId != null) {
      final data = await ChitSchemeApiService.fetchChitStatement(int.parse(widget.chitId.toString()));
      if (mounted) {
        setState(() {
          if (data != null && data['status'] == true && data['data'] != null && data['data']['transactions'] != null) {
            _transactions = data['data']['transactions'];
          }
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    try {
      final formatter = NumberFormat('#,##,###.00');
      if (amount is int) return formatter.format(amount);
      if (amount is double) return formatter.format(amount);
      if (amount is String) return formatter.format(double.parse(amount));
    } catch (e) {
      return amount.toString();
    }
    return amount.toString();
  }

  Future<void> _onDownload() async {
    if (_transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No transactions to download')),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating PDF...'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF007A55),
      ),
    );
    
    await PdfGenerator.generateChitStatement(_transactions, widget.chitId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved to Downloads folder!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF007A55),
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
        backgroundColor: const Color(0xFFF3F3F5),
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
          'Chit Statement',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NeedHelpScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF9B9B9B),
                  width: 0.5.w,
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/scheme_images/need_help.png',
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Need Help ?',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: Image.asset(
              'assets/home_images/notification.png',
              width: 24.w,
              height: 24.h,
            ),
          ),
          SizedBox(width: 16.w),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(
            height: 1.h,
            thickness: 1.h,
            color: const Color(0xFFE2E8F0),
          ),
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SizedBox(
                                  width: constraints.maxWidth,
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: _buildTableCard(constraints.maxHeight),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    _buildBottomActions(),
                  ],
                ),
          const ChatboxWidget(),
        ],
      ),
    ));
  }

  Widget _buildTableCard(double minWidth) {
    double totalWidth = 50.w + 90.w + 140.w + 80.w + 80.w + 80.w + 80.w;
    double scale = minWidth > totalWidth ? minWidth / totalWidth : 1.0;
    double w1 = 50.w * scale;
    double w2 = 90.w * scale;
    double w3 = 140.w * scale;
    double w4 = 80.w * scale;
    double w5 = 80.w * scale;
    double w6 = 80.w * scale;
    double w7 = 80.w * scale;

    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFCBD5E1),
          width: 1.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeaderRow(w1, w2, w3, w4, w5, w6, w7),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _transactions.length; i++)
                    _buildDataRow(_transactions[i], i, w1, w2, w3, w4, w5, w6, w7),
                  if (_transactions.length < 10)
                    for (int i = _transactions.length; i < 10; i++)
                      _buildDataRow({}, i, w1, w2, w3, w4, w5, w6, w7),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(double w1, double w2, double w3, double w4, double w5, double w6, double w7) {
    return Container(
      color: const Color(0xFF007A55),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderCell('SL. NO.', width: w1),
          _buildHeaderCell('DATE', width: w2),
          _buildHeaderCell('TYPE', width: w3),
          _buildHeaderCell('DIVIDEND', width: w4),
          _buildHeaderCell('DEBIT', width: w5),
          _buildHeaderCell('CREDIT', width: w6),
          _buildHeaderCell('BALANCE', width: w7, isLast: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {required double width, bool isLast = false}) {
    return Container(
      width: width,
      height: 40.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : BorderSide(color: const Color(0xFF0B6347), width: 1.w),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3.w,
        ),
      ),
    );
  }

  Widget _buildDataRow(dynamic entry, int index, double w1, double w2, double w3, double w4, double w5, double w6, double w7) {
    final isEven = index % 2 == 0;
    final rowBg = isEven ? Colors.white : const Color(0xFFF8FAFC);
    final isEmptyRow = entry is Map && entry.isEmpty;

    return Container(
      color: rowBg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDataCell(isEmptyRow ? '' : (entry['sno']?.toString() ?? ''), width: w1, isBold: true),
          _buildDataCell(isEmptyRow ? '' : (entry['date']?.toString() ?? ''), width: w2),
          _buildDataCell(isEmptyRow ? '' : (entry['type']?.toString() ?? ''), width: w3),
          _buildDataCell(isEmptyRow ? '' : _formatAmount(entry['dividend']), width: w4),
          _buildDataCell(isEmptyRow ? '' : _formatAmount(entry['debit']), width: w5),
          _buildDataCell(isEmptyRow ? '' : _formatAmount(entry['credit']), width: w6),
          _buildDataCell(isEmptyRow ? '' : _formatAmount(entry['balance']), width: w7, isBold: true, isInstallment: true, isLast: true),
        ],
      ),
    );
  }

  Widget _buildDataCell(
    String value, {
    required double width,
    bool isBold = false,
    bool isInstallment = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      height: 36.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : BorderSide(color: const Color(0xFFE2E8F0), width: 1.w),
          top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.h),
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isInstallment
              ? const Color(0xFF0F172A)
              : (isBold ? const Color(0xFF1E293B) : const Color(0xFF475569)),
          fontSize: 12.sp,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 20.h),
      child: SizedBox(
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton.icon(
          onPressed: _onDownload,
          icon: Icon(
            Icons.file_download_outlined,
            color: Colors.white,
            size: 20.sp,
          ),
          label: Text(
            'Download Statement',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007A55),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
        ),
      ),
    );
  }
}
