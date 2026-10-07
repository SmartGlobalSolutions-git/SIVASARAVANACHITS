import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/statements/app_colors.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';
import 'package:intl/intl.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/utils/pdf_generator.dart';
import '../Home_Sections/drawers_screen.dart';

class PassbookStatementScreen extends StatefulWidget {
  final dynamic chitId;
  final String? dateRange;
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;

  const PassbookStatementScreen({
    super.key,
    this.chitId,
    this.dateRange,
    this.onBackTap,
    this.onMenuTap,
  });

  @override
  State<PassbookStatementScreen> createState() => _PassbookStatementScreenState();
}

class _PassbookStatementScreenState extends State<PassbookStatementScreen> {
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
      final data = await ChitSchemeApiService.fetchPassbookStatement(int.parse(widget.chitId.toString()));
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
        backgroundColor: AppColors.primary,
      ),
    );
    
    await PdfGenerator.generatePassbookStatement(_transactions, widget.chitId);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved to Downloads folder!'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _onShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sharing Passbook Statement...'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
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
          backgroundColor: AppColors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu, color: AppColors.textDark, size: 24.sp),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
        title: Text(
          'Passbook',
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(
            height: 1.h,
            thickness: 1.h,
            color: AppColors.divider,
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
    double totalWidth = 60.w + 120.w + 180.w + 120.w;
    double scale = minWidth > totalWidth ? minWidth / totalWidth : 1.0;
    double w1 = 60.w * scale;
    double w2 = 120.w * scale;
    double w3 = 180.w * scale;
    double w4 = 120.w * scale;

    return Container(
      constraints: BoxConstraints(minWidth: minWidth),
      decoration: BoxDecoration(
        color: AppColors.white,
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
          _buildHeaderRow(w1, w2, w3, w4),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < _transactions.length; i++)
                    _buildDataRow(_transactions[i], i, w1, w2, w3, w4),
                  if (_transactions.length < 10)
                    for (int i = _transactions.length; i < 10; i++)
                      _buildDataRow({}, i, w1, w2, w3, w4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(double w1, double w2, double w3, double w4) {
    return Container(
      color: const Color(0xFF007A55),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderCell('S.NO', width: w1),
          _buildHeaderCell('RECEIPT DATE', width: w2),
          _buildHeaderCell('TRANSACTION TYPE', width: w3),
          _buildHeaderCell('AMOUNT', width: w4, isLast: true),
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

  Widget _buildDataRow(dynamic entry, int index, double w1, double w2, double w3, double w4) {
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
          _buildDataCell(isEmptyRow ? '' : (entry['transaction_type']?.toString() ?? ''), width: w3),
          _buildDataCell(isEmptyRow ? '' : _formatAmount(entry['collection']), width: w4, isBold: true, isInstallment: true, isLast: true),
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
      color: AppColors.white,
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: ElevatedButton.icon(
                onPressed: _onDownload,
                icon: Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                  size: 20.sp,
                ),
                label: Text(
                  'Download',
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
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: OutlinedButton.icon(
                onPressed: _onShare,
                icon: Icon(
                  Icons.share_outlined,
                  color: const Color(0xFF007A55),
                  size: 20.sp,
                ),
                label: Text(
                  'Share',
                  style: TextStyle(
                    color: const Color(0xFF007A55),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: const Color(0xFF007A55),
                    width: 1.5.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
