import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../services/chit_scheme_api.dart';
import '../../services/payment_api.dart';
import '../../services/prebid_api.dart';
import '../../services/reward_api.dart';
import '../../services/help_support_api.dart';
import '../../services/shared_prefs_helper.dart';

import '../Home_Sections/drawers_screen.dart';
import '../Home_Sections/payment.dart';
import '../Home_Sections/my_chits.dart';
import '../Home_Sections/passbook.dart';
import '../Home_Sections/need_help_screen.dart';
import '../payment_sections/payment_history.dart';
import '../Prebitting/prebitting.dart';
import '../chit_schemes/chit_schemes.dart';
import '../reward/reward.dart';
import 'calculator_screen.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onMenuTap;
  const ChatbotScreen({super.key, this.onBackTap, this.onMenuTap});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  String _userName = '';

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          "👋 Hello! I'm your Siva Saravana AI Assistant.\n\nI have live access to your chits, payment dues, auction pre-bids, and schemes across the app.\n\nHow can I help you today? You can type a question or tap any of the suggested questions below!",
      'hasToolCard': false,
    },
  ];

  // Suggested questions from all sections of the app
  final List<Map<String, dynamic>> _suggestedQuestions = [
    {
      'label': 'Next Payment Due',
      'icon': Icons.payment_outlined,
      'query': 'When is my next payment due?',
    },
    {
      'label': 'My Active Chits',
      'icon': Icons.assignment_outlined,
      'query': 'What are my active chit details?',
    },
    {
      'label': 'Running Balance',
      'icon': Icons.account_balance_wallet_outlined,
      'query': 'What is my current running balance?',
    },
    {
      'label': 'Payment History',
      'icon': Icons.history_edu_outlined,
      'query': 'Show my payment history',
    },
    {
      'label': 'Pre-Bidding Status',
      'icon': Icons.gavel_outlined,
      'query': 'Can I participate in Pre-Bidding?',
    },
    {
      'label': 'Available Schemes',
      'icon': Icons.trending_up_outlined,
      'query': 'What new chit schemes are available?',
    },
    {
      'label': 'Bid Calculator',
      'icon': Icons.calculate_outlined,
      'query': 'How do I calculate auction dividend?',
    },
    {
      'label': 'My Reward Points',
      'icon': Icons.card_giftcard_outlined,
      'query': 'What are my reward points?',
    },
    {
      'label': 'Passbook Statement',
      'icon': Icons.menu_book_outlined,
      'query': 'How to download statement or passbook?',
    },
    {
      'label': 'Customer Support',
      'icon': Icons.support_agent_outlined,
      'query': 'How can I contact customer support?',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await SharedPrefsHelper.getUserName();
    if (name.isNotEmpty && mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  String _formatAmount(dynamic amount) {
    if (amount == null) return '0';
    final n = double.tryParse(amount.toString());
    if (n == null) return amount.toString();
    if (n % 1 == 0) {
      return NumberFormat('#,##,###').format(n.toInt());
    }
    return NumberFormat('#,##,###.##').format(n);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleUserQuery(String query) async {
    final text = query.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'hasToolCard': false,
      });
      _isThinking = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      final responseMap = await _processAiQuery(text);
      if (!mounted) return;

      setState(() {
        _isThinking = false;
        _messages.add(responseMap);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint('AI Query Error: $e');
      if (!mounted) return;
      setState(() {
        _isThinking = false;
        _messages.add({
          'isUser': false,
          'text':
              "I apologize, but I could not retrieve that information right now. Please check your network or try again shortly.",
          'hasToolCard': false,
        });
      });
      _scrollToBottom();
    }
  }

  // Real AI reasoning engine connected to live APIs
  Future<Map<String, dynamic>> _processAiQuery(String text) async {
    final q = text.toLowerCase();

    // 1. Payment Due / Next Payment
    if ((q.contains('payment') || q.contains('pay') || q.contains('due') || q.contains('installment')) &&
        (q.contains('when') || q.contains('next') || q.contains('pending') || q.contains('date') || q.contains('how much'))) {
      final myChits = await ChitSchemeApiService.fetchMyChits();
      if (myChits != null && myChits.isNotEmpty) {
        final sb = StringBuffer();
        sb.writeln("💳 **Upcoming Payment Schedule:**\n");

        for (var chit in myChits) {
          final chitName = chit['Chit Name'] ?? chit['Group Name'] ?? 'Chit';
          final tNo = chit['t_no'] ?? '-';
          final dueDate = chit['Ag_date'] ?? chit['Start Date'] ?? '15th of the month';
          final insAmt = chit['Ins Amount'] ?? chit['Actual Due'] ?? chit['Due'] ?? 0;
          final pendingDue = chit['Pending Due'] ?? 0;

          sb.writeln("• **$chitName** (Ticket #$tNo):");
          sb.writeln("  📅 Due Date: **$dueDate**");
          sb.writeln("  💵 Installment: **₹${_formatAmount(insAmt)}**");
          if (pendingDue.toString() != '0') {
            sb.writeln("  ⚠️ Pending Due: **₹${_formatAmount(pendingDue)}**");
          } else {
            sb.writeln("  ✅ Dues are up to date!");
          }
          sb.writeln();
        }
        sb.write("You can make online payments securely using UPI, Debit Card or NetBanking.");

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'Pay Chit Due',
          'cardSubtitle': 'Make quick payments online without visiting branch',
          'cardButtonText': 'Pay Now',
          'cardIcon': Icons.payment,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentScreen()),
              ),
        };
      }
    }

    // 2. Payment History / Past Payments / Receipts
    if (q.contains('history') ||
        q.contains('receipt') ||
        q.contains('approved') ||
        q.contains('past payment') ||
        q.contains('transaction') ||
        (q.contains('payment') && q.contains('show'))) {
      final historyData = await PaymentApiService.fetchPaymentHistory();
      if (historyData != null && historyData['payments'] is List) {
        final payments = historyData['payments'] as List<dynamic>;
        final totalApproved = historyData['total_approved'];
        final totalPending = historyData['total_pending'];
        final count = historyData['count'] ?? payments.length;

        final sb = StringBuffer();
        sb.writeln("🧾 **Your Payment History Summary:**\n");
        sb.writeln("• Total Approved: **₹${_formatAmount(totalApproved)}**");
        if (totalPending != null && totalPending.toString() != '0') {
          sb.writeln("• Pending Approval: **₹${_formatAmount(totalPending)}**");
        }
        sb.writeln("• Total Transactions: **$count**\n");

        if (payments.isNotEmpty) {
          sb.writeln("📌 **Recent Payments:**");
          for (var p in payments.take(3)) {
            final amt = p['amount_display'] ?? p['amount'] ?? '0';
            final date = p['datetime_display'] ?? p['date'] ?? '';
            final group = p['group_name'] ?? 'Chit';
            final status = p['status'] ?? 'Approved';
            sb.writeln("• **₹$amt** on $date ($group) — Status: **$status**");
          }
        }

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'Payment History',
          'cardSubtitle': 'View all approved and pending receipts',
          'cardButtonText': 'View History',
          'cardIcon': Icons.receipt_long,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PaymentHistory()),
              ),
        };
      }
    }

    // 3. My Chit Details / Active Chits
    if (q.contains('active chit') ||
        q.contains('my chit') ||
        q.contains('chit detail') ||
        q.contains('chit value') ||
        q.contains('ticket') ||
        q.contains('tenure') ||
        q.contains('enrollment')) {
      final myChits = await ChitSchemeApiService.fetchMyChits();
      if (myChits != null && myChits.isNotEmpty) {
        final sb = StringBuffer();
        sb.writeln("📋 **Your Active Chit Enrollments:**\n");

        for (var chit in myChits) {
          final chitName = chit['Chit Name'] ?? chit['Group Name'] ?? 'Chit';
          final chitVal = chit['Chit Value'] ?? 0;
          final tNo = chit['t_no'] ?? '-';
          final paidDue = chit['Paid Due'] ?? 0;
          final totalDue = chit['No Ins'] ?? 20;
          final status = chit['Status'] ?? 'Non-Prized';
          final sDate = chit['Start Date'] ?? '-';
          final eDate = chit['End Date'] ?? '-';

          sb.writeln("• **$chitName** (Ticket #$tNo):");
          sb.writeln("  💰 Chit Value: **₹${_formatAmount(chitVal)}**");
          sb.writeln("  📊 Installments: **$paidDue / $totalDue Paid**");
          sb.writeln("  🏷️ Status: **$status**");
          sb.writeln("  🗓️ Period: $sDate to $eDate");
          sb.writeln();
        }

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'My Chits Overview',
          'cardSubtitle': 'Inspect passbooks, statements and member details',
          'cardButtonText': 'View My Chits',
          'cardIcon': Icons.folder_shared_outlined,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyChitsScreen()),
              ),
        };
      }
    }

    // 4. Running Balance
    if (q.contains('running balance') ||
        q.contains('balance') ||
        q.contains('excess') ||
        q.contains('cur_run_bal')) {
      final myChits = await ChitSchemeApiService.fetchMyChits();
      if (myChits != null && myChits.isNotEmpty) {
        final sb = StringBuffer();
        sb.writeln("💰 **Your Running Balance Breakdown:**\n");

        for (var chit in myChits) {
          final chitName = chit['Chit Name'] ?? chit['Group Name'] ?? 'Chit';
          final rb = chit['Running Balance'] ?? chit['cur_run_bal'] ?? 0;
          final rbNum = double.tryParse(rb.toString()) ?? 0;

          sb.writeln("• **$chitName**: **₹${_formatAmount(rb)}**");
          if (rbNum <= 0) {
            sb.writeln("  (Advance credit / dues settled ✅)");
          } else {
            sb.writeln("  (Pending dues of ₹${_formatAmount(rb)})");
          }
        }
        sb.writeln(
            "\n💡 *Rule: Maintaining a running balance below ₹100 keeps you eligible for pre-bidding in upcoming auctions!*");

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'My Chits Account',
          'cardSubtitle': 'View running balance and auction eligibility',
          'cardButtonText': 'View Details',
          'cardIcon': Icons.account_balance_wallet_outlined,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyChitsScreen()),
              ),
        };
      }
    }

    // 5. Pre-Bidding / Auctions
    if (q.contains('prebid') ||
        q.contains('pre-bid') ||
        q.contains('auction') ||
        q.contains('bid') ||
        q.contains('prize money')) {
      final prebidList = await PrebidApiService.fetchPrebidList();
      if (prebidList != null && prebidList.isNotEmpty) {
        final sb = StringBuffer();
        sb.writeln("🔨 **Pre-Bidding & Auction Status:**\n");

        for (var item in prebidList) {
          final name = item['Group Name'] ?? item['Chit Name'] ?? 'Chit';
          final tNo = item['t_no'] ?? '-';
          final allowed = item['Prebid Allowed'] == true;
          final date = item['Ag_date'] ?? 'Upcoming';

          sb.writeln("• **$name** (Ticket #$tNo):");
          sb.writeln("  📅 Auction Date: **$date**");
          if (allowed) {
            sb.writeln("  ✅ **Eligible for Pre-Bidding!** You can submit your discount bid.");
          } else {
            sb.writeln("  ℹ️ ${item['Prebid Message'] ?? 'Pre-bidding not eligible.'}");
          }
          sb.writeln();
        }
        sb.write("Pre-bidding lets non-prized members place their discount bid securely before the live auction closes.");

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'Pre-Bidding Screen',
          'cardSubtitle': 'Place your auction discount bid in advance',
          'cardButtonText': 'Open Pre-Bidding',
          'cardIcon': Icons.gavel_outlined,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrebiddingListScreen()),
              ),
        };
      }
    }

    // 6. Available Schemes / New Investments
    if (q.contains('scheme') ||
        q.contains('available') ||
        q.contains('new plan') ||
        q.contains('investment') ||
        q.contains('join') ||
        q.contains('subscribe')) {
      final available = await ChitSchemeApiService.fetchAvailableChits();
      if (available != null && available.isNotEmpty) {
        final sb = StringBuffer();
        sb.writeln("📈 **Top Available Chit Schemes for Subscription:**\n");

        for (var s in available.take(3)) {
          final sName = s['scheme_name'] ?? s['group_name'] ?? 'Chit Scheme';
          final val = s['chit_value'] ?? s['scheme_value'] ?? 0;
          final ins = s['installment'] ?? s['ins_amount'] ?? 0;
          final tenure = s['tenure'] ?? s['months'] ?? '20';
          final vacant = s['bal_sub'];

          sb.writeln("• **$sName**:");
          sb.writeln("  💰 Chit Value: **₹${_formatAmount(val)}**");
          sb.writeln("  💵 Monthly Installment: **₹${_formatAmount(ins)}**");
          sb.writeln("  ⏳ Tenure: **$tenure Months**");
          if (vacant != null) {
            sb.writeln("  🎟️ Vacant Slots: **$vacant seats available**");
          }
          sb.writeln();
        }
        sb.write("Chit funds offer disciplined savings and borrowing flexibility without collateral!");

        return {
          'isUser': false,
          'text': sb.toString().trim(),
          'hasToolCard': true,
          'cardTitle': 'Chit Schemes',
          'cardSubtitle': 'Explore available chit groups and enroll today',
          'cardButtonText': 'Explore Schemes',
          'cardIcon': Icons.trending_up,
          'cardAction': () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChitSchemesScreen(initialTab: 1)),
              ),
        };
      }
    }

    // 7. Dividend / Calculator
    if (q.contains('dividend') ||
        q.contains('calculate') ||
        q.contains('calculator') ||
        q.contains('return') ||
        q.contains('growth')) {
      return {
        'isUser': false,
        'text':
            "🧮 **How Chit Dividend Works:**\n\nEach month, the auction discount is distributed equally among all non-prized subscribers as a **dividend**. This reduces your actual monthly payment well below the regular chit installment!\n\nYou can calculate your estimated dividends and returns for different bid amounts using our **Bid Calculator Tool**.",
        'hasToolCard': true,
        'cardTitle': 'Bid Calculator Tool',
        'cardSubtitle': 'Estimate your returns and dividend instantly',
        'cardButtonText': 'Open Calculator',
        'cardIcon': Icons.calculate_outlined,
        'cardAction': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CalculatorScreen()),
            ),
      };
    }

    // 8. Rewards & Points
    if (q.contains('reward') ||
        q.contains('point') ||
        q.contains('achievement') ||
        q.contains('badge') ||
        q.contains('refer')) {
      final rewardData = await RewardApiService.fetchRewardsAchievements();
      String pointsMsg = "";
      if (rewardData != null && rewardData['points'] != null) {
        pointsMsg = "\n\n🌟 Your Reward Balance: **${rewardData['points']} Points**";
      }
      return {
        'isUser': false,
        'text':
            "🎁 **Siva Saravana Rewards & Achievements:**$pointsMsg\n\nYou earn reward points when you:\n• Pay your monthly chit installments on time ⏰\n• Refer friends and family to join our schemes 👥\n• Reach long-term savings milestones 🏆\n\nYou can track and redeem points directly in the Rewards section!",
        'hasToolCard': true,
        'cardTitle': 'Rewards & Achievements',
        'cardSubtitle': 'View your points balance, tier, and badges',
        'cardButtonText': 'View Rewards',
        'cardIcon': Icons.card_giftcard_outlined,
        'cardAction': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RewardsAchievementsScreen()),
            ),
      };
    }

    // 9. Passbook & Statements
    if (q.contains('passbook') ||
        q.contains('statement') ||
        q.contains('download') ||
        q.contains('pdf') ||
        q.contains('ledger')) {
      return {
        'isUser': false,
        'text':
            "📖 **Chit Statement & Passbook:**\n\nYou can view and download official statements for your chits:\n\n1. Open the **Passbook** screen.\n2. Choose your Chit ID.\n3. View transaction breakdown.\n4. Tap **Download PDF** to save the verified statement directly to your phone storage.",
        'hasToolCard': true,
        'cardTitle': 'Passbook & Statement',
        'cardSubtitle': 'View transaction ledger and download verified PDF',
        'cardButtonText': 'Open Passbook',
        'cardIcon': Icons.menu_book_outlined,
        'cardAction': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PassbookScreen()),
            ),
      };
    }

    // 10. Help & Support
    if (q.contains('help') ||
        q.contains('support') ||
        q.contains('contact') ||
        q.contains('phone') ||
        q.contains('call') ||
        q.contains('address') ||
        q.contains('office') ||
        q.contains('branch')) {
      final contact = await HelpSupportApiService.fetchHelpSupport();
      final phone = contact?['phone'] ?? '+91 98765 43210';
      final email = contact?['email'] ?? 'support@sivasaravanachits.com';
      final address = contact?['address'] ?? 'Siva Saravana Chit Funds Pvt. Ltd., Tamil Nadu';

      return {
        'isUser': false,
        'text':
            "📞 **Customer Support Desk:**\n\nOur team is here to help you:\n\n• 📱 Phone: **$phone**\n• ✉️ Email: **$email**\n• 🏢 Office: **$address**\n• ⏰ Working Hours: **Mon – Sat (9:30 AM – 6:30 PM)**\n\nYou can also raise a support ticket directly from the app.",
        'hasToolCard': true,
        'cardTitle': 'Need Help & Support',
        'cardSubtitle': 'Raise a ticket or connect with our support agents',
        'cardButtonText': 'Get Help',
        'cardIcon': Icons.support_agent_outlined,
        'cardAction': () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NeedHelpScreen()),
            ),
      };
    }

    // 11. Greeting
    if (q.contains('hi') ||
        q.contains('hello') ||
        q.contains('hey') ||
        q.contains('vanakkam') ||
        q.contains('good morning') ||
        q.contains('good evening')) {
      final greetingName = _userName.isNotEmpty ? ' $_userName' : '';
      return {
        'isUser': false,
        'text':
            "👋 Hello$greetingName! I'm your AI Chit Assistant.\n\nI can help you check upcoming dues, view your active chits, inspect running balance, pre-bid in auctions, or explore new investment schemes.\n\nTap any suggested question below or type what you need!",
        'hasToolCard': false,
      };
    }

    // 12. Default Fallback
    return {
      'isUser': false,
      'text':
          "I can assist you with all sections of the Siva Saravana app! Here are common queries you can ask me:\n\n• 💳 **'When is my next payment due?'**\n• 📋 **'What are my active chit details?'**\n• 💰 **'What is my running balance?'**\n• 🧾 **'Show my payment history'**\n• 🔨 **'Can I participate in Pre-Bidding?'**\n• 📈 **'What new chit schemes are available?'**\n• 🧮 **'How do I calculate auction dividend?'**\n• 📞 **'How can I contact customer support?'**\n\nOr tap any of the suggested question buttons below!",
      'hasToolCard': false,
    };
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double scaleW = screenSize.width / 360.0;
    final double scaleH = screenSize.height / 800.0;

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
        backgroundColor: const Color(0xFFF7F8FA),
        onDrawerChanged: (isOpened) {
          if (widget.onMenuTap == null) {
            setState(() {
              _isDrawerOpen = isOpened;
            });
          }
        },
        drawer: widget.onMenuTap == null ? const DrawersScreen() : null,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(57 * scaleH.clamp(0.85, 1.2)),
          child: AppBar(
            backgroundColor: const Color(0xFFFFFFFF),
            elevation: 0,
            titleSpacing: 0,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: Icon(
                (widget.onBackTap != null || Navigator.canPop(context))
                    ? Icons.arrow_back
                    : Icons.menu,
                color: Colors.black87,
                size: 22,
              ),
              onPressed: () {
                if (widget.onBackTap != null) {
                  widget.onBackTap!();
                } else if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else if (widget.onMenuTap != null) {
                  widget.onMenuTap!();
                } else {
                  _scaffoldKey.currentState?.openDrawer();
                }
              },
            ),
            title: Text(
              'Chit AI Assistant',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E2638),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Chat Messages List
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scaleW.clamp(0.85, 1.2),
                    vertical: 12 * scaleH.clamp(0.85, 1.2),
                  ),
                  child: Column(
                    children: [
                      // Top Centered Bot Logo
                      Center(
                        child: Container(
                          width: 68 * scaleW.clamp(0.85, 1.2),
                          height: 68 * scaleW.clamp(0.85, 1.2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF018F46),
                              width: 3.0,
                            ),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/chatbot_ai.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.smart_toy,
                                      size: 38, color: Color(0xFF018F46)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6 * scaleH.clamp(0.85, 1.2)),

                      // Subtitle
                      Text(
                        'Siva Saravana AI Assistant',
                        style: GoogleFonts.inter(
                          fontSize: 12 * scaleW.clamp(0.85, 1.2),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF757575),
                        ),
                      ),
                      SizedBox(height: 14 * scaleH.clamp(0.85, 1.2)),

                      // Chat messages
                      ..._messages.map(
                          (msg) => _buildMessageItem(msg, scaleW, scaleH)),

                      // Thinking Indicator
                      if (_isThinking) ...[
                        _buildThinkingBubble(scaleW, scaleH),
                      ],
                    ],
                  ),
                ),
              ),

              // Suggested Questions Horizontal Chips Bar
              Container(
                height: 38,
                margin: const EdgeInsets.only(bottom: 6),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _suggestedQuestions.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final q = _suggestedQuestions[index];
                    return ActionChip(
                      avatar: Icon(
                        q['icon'] as IconData,
                        size: 15,
                        color: const Color(0xFF018F46),
                      ),
                      label: Text(
                        q['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1E2638),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 0),
                      onPressed: () =>
                          _handleUserQuery(q['query'] as String),
                    );
                  },
                ),
              ),

              // Bottom Input Bar
              Container(
                padding: EdgeInsets.fromLTRB(
                  16 * scaleW.clamp(0.85, 1.2),
                  4,
                  16 * scaleW.clamp(0.85, 1.2),
                  10,
                ),
                color: const Color(0xFFF7F8FA),
                child: Container(
                  height: 48 * scaleH.clamp(0.85, 1.2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      // Input Text Field
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: GoogleFonts.inter(
                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
                            color: const Color(0xFF1E2638),
                          ),
                          onSubmitted: (val) => _handleUserQuery(val),
                          decoration: InputDecoration(
                            hintText: 'Ask your AI Chit Assistant...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5 * scaleW.clamp(0.85, 1.2),
                              color: const Color(0xFF9CA3AF),
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),

                      // Send Button
                      GestureDetector(
                        onTap: () => _handleUserQuery(_messageController.text),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF018F46),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThinkingBubble(double scaleW, double scaleH) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28 * scaleW.clamp(0.85, 1.2),
            height: 28 * scaleW.clamp(0.85, 1.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF018F46), width: 1.5),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: Image.asset(
                'assets/images/chatbot_ai.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.smart_toy, size: 16, color: Color(0xFF018F46)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF018F46),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Analyzing account data...',
                  style: GoogleFonts.inter(
                    fontSize: 12.5 * scaleW.clamp(0.85, 1.2),
                    color: const Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
      Map<String, dynamic> msg, double scaleW, double scaleH) {
    final bool isUser = msg['isUser'] as bool;
    final String text = msg['text'] as String;
    final bool hasToolCard = msg['hasToolCard'] as bool;

    if (isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 250 * scaleW.clamp(0.85, 1.25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF018F46),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13.5 * scaleW.clamp(0.85, 1.2),
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.35,
              ),
            ),
          ),
        ),
      );
    }

    // Bot message
    return Padding(
      padding: EdgeInsets.only(bottom: 14 * scaleH.clamp(0.85, 1.2)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small bot avatar on the left
          Container(
            width: 28 * scaleW.clamp(0.85, 1.2),
            height: 28 * scaleW.clamp(0.85, 1.2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF018F46), width: 1.5),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: Image.asset(
                'assets/images/chatbot_ai.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.smart_toy, size: 16, color: Color(0xFF018F46)),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Message bubble
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.inter(
                      fontSize: 13.5 * scaleW.clamp(0.85, 1.2),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF333333),
                      height: 1.45,
                    ),
                  ),

                  // Optional embedded Tool Card / Action Card
                  if (hasToolCard) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  msg['cardIcon'] as IconData? ??
                                      Icons.smart_button_outlined,
                                  color: const Color(0xFF018F46),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  msg['cardTitle'] as String? ?? 'Action',
                                  style: GoogleFonts.inter(
                                    fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1E2638),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            msg['cardSubtitle'] as String? ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12 * scaleW.clamp(0.85, 1.2),
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 36,
                            child: OutlinedButton(
                              onPressed: () {
                                if (msg['cardAction'] != null) {
                                  (msg['cardAction'] as VoidCallback)();
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF018F46), width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    msg['cardButtonText'] as String? ??
                                        'Open Screen',
                                    style: GoogleFonts.inter(
                                      fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF018F46),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: Color(0xFF018F46),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
