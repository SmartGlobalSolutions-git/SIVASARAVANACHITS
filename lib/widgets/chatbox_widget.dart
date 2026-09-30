import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:siva_saravana/Screens/growth_plan/chatbot_screen.dart';

class ChatboxWidget extends StatefulWidget {
  const ChatboxWidget({super.key});

  @override
  State<ChatboxWidget> createState() => _ChatboxWidgetState();
}

class _ChatboxWidgetState extends State<ChatboxWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 25.w,
      bottom: 40.h,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Bee-like movement: hovering up and down, slightly side to side
          final dy = math.sin(_controller.value * math.pi * 2) * 8.0;
          final dx = math.cos(_controller.value * math.pi * 4) * 4.0;
          
          return Transform.translate(
            offset: Offset(dx, dy),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatbotScreen(),
              ),
            );
          },
          child: Image.asset(
            'assets/scheme_images/image 1272.png',
            width: 45.w,
            height: 45.h,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 45.w,
                height: 45.h,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy, color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
