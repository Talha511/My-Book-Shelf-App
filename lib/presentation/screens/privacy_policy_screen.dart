import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Privacy Policy', style: context.ts.h2),
            const SizedBox(height: 16),
            Text(
              'Last Updated: October 2023',
              style: context.ts.bodySmall.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Information We Collect',
              'We collect information to provide better services to all our users. This includes your email address for account creation and any books you upload or mark as favorites.',
            ),
            _buildSection(
              context,
              '2. How We Use Information',
              'We use the information we collect to maintain and improve our services, and to provide personalized experiences, such as recommendations based on your favorite books.',
            ),
            _buildSection(
              context,
              '3. Information Sharing',
              'We do not share your personal information with companies, organizations, or individuals outside of MyBookShelf except in the following cases: with your consent, for external processing, or for legal reasons.',
            ),
            _buildSection(
              context,
              '4. Data Security',
              'We work hard to protect MyBookShelf and our users from unauthorized access to or unauthorized alteration, disclosure, or destruction of information we hold.',
            ),
            _buildSection(
              context,
              '5. Your Rights',
              'You have the right to access, update, or delete your personal information at any time through your profile settings.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Contact us at: support@mybookshelf.com',
                style: context.ts.bodyMedium.copyWith(color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.ts.h3),
          const SizedBox(height: 8),
          Text(
            content,
            style: context.ts.bodyMedium.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
