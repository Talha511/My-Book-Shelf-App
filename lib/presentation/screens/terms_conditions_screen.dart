import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Terms & Conditions', style: context.ts.h2),
            const SizedBox(height: 16),
            Text(
              'Last Updated: October 2023',
              style: context.ts.bodySmall.copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              '1. Acceptance of Terms',
              'By accessing or using the MyBookShelf application, you agree to be bound by these Terms and Conditions. If you do not agree to all of these terms, do not use the application.',
            ),
            _buildSection(
              context,
              '2. User Accounts',
              'You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.',
            ),
            _buildSection(
              context,
              '3. Content and Use',
              'MyBookShelf allows you to read, favorite, and upload books. You represent and warrant that you own or have the necessary rights to any content you upload.',
            ),
            _buildSection(
              context,
              '4. Prohibited Conduct',
              'You agree not to use the application for any unlawful purpose or in any way that could damage, disable, or impair the service.',
            ),
            _buildSection(
              context,
              '5. Limitation of Liability',
              'MyBookShelf shall not be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use of the service.',
            ),
            _buildSection(
              context,
              '6. Changes to Terms',
              'We reserve the right to modify these terms at any time. We will notify you of any changes by updating the "Last Updated" date at the top of this page.',
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Questions? Contact us: legal@mybookshelf.com',
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
