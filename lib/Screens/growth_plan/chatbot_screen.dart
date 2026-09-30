import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text': "Hello! I'm your Chit Assistant.\nHow can I help you today?",
      'hasToolCard': false,
    },
    {
      'isUser': true,
      'text': "How do I calculate my dividend?",
      'hasToolCard': false,
    },
    {
      'isUser': false,
      'text':
          "You can calculate your potential dividend for upcoming auctions using our Bid Calculator. It considers the total pot, your bid amount, and the number of active participants.",
      'hasToolCard': true,
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'isUser': true,
        'text': text,
        'hasToolCard': false,
      });
      _messageController.clear();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(57 * scaleH.clamp(0.85, 1.2)),
        child: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 57 * scaleH.clamp(0.85, 1.2),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 22),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Chatbot',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16 * scaleW.clamp(0.85, 1.2),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              letterSpacing: 0,
              height: 1.0,
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
                    // Top Centered Bot Logo (Green circle with chatbot_ai.png)
                    Center(
                      child: Container(
                        width: 72 * scaleW.clamp(0.85, 1.2),
                        height: 72 * scaleW.clamp(0.85, 1.2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF018F46),
                            width: 3.5,
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
                                    size: 40, color: Color(0xFF018F46)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8 * scaleH.clamp(0.85, 1.2)),

                    // Timestamp
                    Text(
                      'Today, 10:42 AM',
                      style: GoogleFonts.inter(
                        fontSize: 12 * scaleW.clamp(0.85, 1.2),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF757575),
                      ),
                    ),
                    SizedBox(height: 16 * scaleH.clamp(0.85, 1.2)),

                    // Chat messages
                    ..._messages.map((msg) => _buildMessageItem(msg, scaleW, scaleH)),
                  ],
                ),
              ),
            ),

            // Bottom Input Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                16 * scaleW.clamp(0.85, 1.2),
                8,
                16 * scaleW.clamp(0.85, 1.2),
                12,
              ),
              color: const Color(0xFFF7F8FA),
              child: Container(
                height: 48 * scaleH.clamp(0.85, 1.2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // Attachment paperclip icon
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.attach_file,
                        color: Color(0xFF6B7280),
                        size: 22,
                      ),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),

                    // Input Text Field
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: GoogleFonts.inter(
                          fontSize: 14 * scaleW.clamp(0.85, 1.2),
                          color: const Color(0xFF1E2638),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        decoration: InputDecoration(
                          hintText: 'Ask Chit Assistant...',
                          hintStyle: GoogleFonts.inter(
                            fontSize: 14 * scaleW.clamp(0.85, 1.2),
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
                      onTap: _sendMessage,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF018F46),
                          borderRadius: BorderRadius.circular(8),
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
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> msg, double scaleW, double scaleH) {
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
              maxWidth: 240 * scaleW.clamp(0.85, 1.25),
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
                      height: 1.4,
                    ),
                  ),

                  // Optional embedded Tool Card (Bid Calculator Tool)
                  if (hasToolCard) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.calculate_outlined,
                                  color: Color(0xFF018F46),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Bid Calculator Tool',
                                style: GoogleFonts.inter(
                                  fontSize: 13 * scaleW.clamp(0.85, 1.2),
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1E2638),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Estimate your returns instantly.',
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
                                Navigator.of(context).pop();
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
                                    'Open Calculator',
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

class CustomBotIcon extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const CustomBotIcon({
    super.key,
    this.size = 50,
    this.onTap,
  });

  @override
  State<CustomBotIcon> createState() => _CustomBotIconState();
}

class _CustomBotIconState extends State<CustomBotIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shakeAnimation;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // Shake rotation: subtle left-right wiggle (in radians)
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.10)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.10, end: 0.10)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.10, end: -0.06)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.06, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 35, // Rest pause before next wiggle
      ),
    ]).animate(_controller);

    // Subtle up-down floating bob
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -4.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -4.0, end: 2.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 2.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounceAnimation.value),
          child: Transform.rotate(
            angle: _shakeAnimation.value,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatbotScreen()),
            );
          }
        },
        child: Image.asset(
          'assets/images/roboto.png',
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            width: widget.size,
            height: widget.size,
            decoration: const BoxDecoration(
              color: Color(0xFFFFB300),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}

