import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/statements/passbook_statement.dart';
import 'package:siva_saravana/widgets/chatbox_widget.dart';
import 'package:siva_saravana/Screens/Home_Sections/drawers_screen.dart';
import 'package:siva_saravana/services/chit_scheme_api.dart';

class PassbookScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;
  final VoidCallback? onMenuTap;
  
  const PassbookScreen({Key? key, this.onBackToHome, this.onMenuTap}) : super(key: key);

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  bool _isLoading = false;
  bool _isFetchingChits = true;
  List<dynamic> _chitList = [];
  String? _selectedChitId;

  @override
  void initState() {
    super.initState();
    _fetchChitList();
  }

  Future<void> _fetchChitList() async {
    final list = await ChitSchemeApiService.fetchCustomerChitIds();
    if (mounted) {
      setState(() {
        _chitList = list ?? [];
        if (_chitList.isNotEmpty) {
          _selectedChitId = _chitList[0]['chit_id'].toString();
        }
        _isFetchingChits = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onSubmit() async {
    final chitId = _selectedChitId;
    if (chitId == null || chitId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Chit ID')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // We can use ChitSchemeApiService.fetchPassbookStatement here
    // But since it's already in the service, let's make sure it's imported.
    final response = await ChitSchemeApiService.fetchPassbookStatement(int.parse(chitId));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['status'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassbookStatementScreen(chitId: chitId),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response?['message'] ?? 'There is no chit for this ID')),
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
        leading: GestureDetector(
          onTap: () {
            if (widget.onMenuTap != null) {
              widget.onMenuTap!();
            } else {
              _scaffoldKey.currentState?.openDrawer();
            }
          },
          child: const Icon(Icons.menu, color: Colors.black),
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Passbook',
          style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w600),
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
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _isFetchingChits
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  dropdownColor: Colors.white,
                                  value: _selectedChitId,
                                  isExpanded: true,
                                  hint: Text('Select Chit', style: TextStyle(fontSize: 13.sp, color: Colors.grey)),
                                  items: _chitList.map((chit) {
                                    final id = chit['chit_id'].toString();
                                    final name = chit['grp_name']?.toString() ?? '';
                                    return DropdownMenuItem<String>(
                                      value: id,
                                      child: Text('$name ($id)', style: TextStyle(fontSize: 14.sp)),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      _selectedChitId = val;
                                    });
                                  },
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
