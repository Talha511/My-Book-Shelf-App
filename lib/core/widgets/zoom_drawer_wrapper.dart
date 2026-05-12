import 'dart:math';
import 'package:flutter/material.dart';
import 'app_drawer.dart';

class ZoomDrawerWrapper extends StatefulWidget {
  final Widget child;
  const ZoomDrawerWrapper({super.key, required this.child});

  static _ZoomDrawerWrapperState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ZoomDrawerWrapperState>();

  @override
  State<ZoomDrawerWrapper> createState() => _ZoomDrawerWrapperState();
}

class _ZoomDrawerWrapperState extends State<ZoomDrawerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
      body: Stack(
        children: [
          // The Drawer (Background)
          const AppDrawer(),

          // The Main Content (Foreground)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double slide = 250.0 * _controller.value;
              double scale = 1.0 - (0.2 * _controller.value);
              double angle = -pi / 10 * _controller.value; // Perspective tilt

              return Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale)
                  ..setEntry(3, 2, 0.001) // Perspective
                  ..rotateY(angle),
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _isOpen ? toggle : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_isOpen ? 32 : 0),
                    child: child,
                  ),
                ),
              );
            },
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
