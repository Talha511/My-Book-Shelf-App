import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ReaderScreen extends StatefulWidget {
  final Book book;

  const ReaderScreen({super.key, required this.book});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  double _fontSize = 18.0;
  Color _backgroundColor = Colors.white;
  Color _textColor = Colors.black87;
  String _fontFamily = 'Serif';

  void _changeTheme(String theme) {
    setState(() {
      if (theme == 'White') {
        _backgroundColor = Colors.white;
        _textColor = Colors.black87;
      } else if (theme == 'Sepia') {
        _backgroundColor = const Color(0xFFF4ECD8);
        _textColor = const Color(0xFF5B4636);
      } else if (theme == 'Dark') {
        _backgroundColor = const Color(0xFF121212);
        _textColor = Colors.grey[300]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(widget.book.title),
        backgroundColor: _backgroundColor,
        elevation: 0,
        foregroundColor: _textColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: _textColor),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.book.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _fontSize + 10,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                  fontFamily: _fontFamily,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'By ${widget.book.author}',
                  style: TextStyle(
                    fontSize: _fontSize - 2,
                    fontStyle: FontStyle.italic,
                    color: _textColor.withValues(alpha: 0.7),
                    fontFamily: _fontFamily,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Divider(),
              ),
              Text(
                widget.book.content.isNotEmpty 
                    ? widget.book.content 
                    : "This is a preview content for ${widget.book.title}. Actual book content will appear here once the full version is uploaded. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.8,
                  color: _textColor,
                  fontFamily: _fontFamily,
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Appearance Settings', style: context.ts.h3),
                  const SizedBox(height: 24),
                  const Text('Font Size', style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _fontSize,
                    min: 14,
                    max: 32,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setModalState(() => _fontSize = value);
                      setState(() => _fontSize = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _themeOption('White', Colors.white, Colors.black87),
                      _themeOption('Sepia', const Color(0xFFF4ECD8), const Color(0xFF5B4636)),
                      _themeOption('Dark', const Color(0xFF121212), Colors.white70),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _themeOption(String label, Color bg, Color text) {
    bool isSelected = (_backgroundColor == bg);
    return GestureDetector(
      onTap: () => _changeTheme(label),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)] : null,
            ),
            child: Center(child: Text('Aa', style: TextStyle(color: text, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
