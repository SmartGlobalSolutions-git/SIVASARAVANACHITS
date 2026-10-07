import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'chit_statement.dart';
import '../Home_Sections/drawers_screen.dart';
import '../../services/chit_scheme_api.dart';

class StatementScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const StatementScreen({Key? key, this.onBackTap, this.onMenuTap}) : super(key: key);

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _chitIdController = TextEditingController();
  bool _isDrawerOpen = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _chitIdController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    final chitId = _chitIdController.text.trim();
    if (chitId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Chit ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await ChitSchemeApiService.fetchChitStatement(int.parse(chitId));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['status'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChitStatementScreen(chitId: chitId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?['message'] ?? 'There is no chit')),
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
        backgroundColor: const Color(0xFFF4F5F9),
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
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              if (widget.onMenuTap != null) {
                widget.onMenuTap!();
              } else {
                _scaffoldKey.currentState?.openDrawer();
              }
            },
          ),
          titleSpacing: 0,
        title: Text(
          'Statement',
          style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Chit ID',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    ),
                    SizedBox(width: 15.w),
                    Text(':', style: TextStyle(fontSize: 14.sp, color: Colors.black87)),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: TextField(
                          controller: _chitIdController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter Chit ID :',
                            hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                            suffixIcon: const Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Center(
                  child: SizedBox(
                    width: 200.w,
                    height: 45.h,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0C8A4B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading 
                          ? SizedBox(
                              height: 20.h, 
                              width: 20.h, 
                              child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : Text(
                              'Submit',
                              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bot Icon
          const ChatboxWidget(),
        ],
      ),
    ));
  }
}
