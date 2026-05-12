import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('How can we help you?', style: context.ts.h2),
          const SizedBox(height: 20),
          _buildSearchField(context),
          const SizedBox(height: 32),
          Text('Frequently Asked Questions', style: context.ts.h3),
          const SizedBox(height: 16),
          _buildFaqItem(context, 'How to download books?', 'You can download books by clicking the download icon on the book details page.'),
          _buildFaqItem(context, 'How to change reading mode?', 'While reading a book, tap on the settings icon in the top right corner to change themes and font sizes.'),
          _buildFaqItem(context, 'Is the app free to use?', 'Yes, MyBookShelf offers a wide range of free books. Some premium titles may require a subscription.'),
          _buildFaqItem(context, 'How to report a bug?', 'You can reach out to our support team at support@mybookshelf.com or use the contact form below.'),
          const SizedBox(height: 32),
          _buildContactSection(context),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search help articles...',
        prefixIcon: const Icon(Icons.search, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: context.ts.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(answer, style: context.ts.bodySmall),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.headset_mic_outlined, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text('Still need help?', style: context.ts.h3),
          const SizedBox(height: 8),
          const Text('Our support team is available 24/7', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }
}
