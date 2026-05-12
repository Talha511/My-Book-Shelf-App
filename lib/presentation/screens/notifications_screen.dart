import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Book Added!',
        'body': '\"The Art of Focus\" by Mark Manson is now available in the library.',
        'time': '10 mins ago',
        'isRead': false,
        'icon': Icons.book_outlined
      },
      {
        'title': 'Recommendation for you',
        'body': 'Based on your interest in Sci-Fi, check out \"Project Hail Mary\".',
        'time': '2 hours ago',
        'isRead': false,
        'icon': Icons.auto_awesome_outlined
      },
      {
        'title': 'Account Security',
        'body': 'Biometric login has been successfully enabled on your device.',
        'time': 'Yesterday',
        'isRead': true,
        'icon': Icons.security_outlined
      },
      {
        'title': 'Welcome to MyBookShelf',
        'body': 'Explore 50+ books and start your reading journey today!',
        'time': '2 days ago',
        'isRead': true,
        'icon': Icons.waving_hand_outlined
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all as read', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text('No notifications yet', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = notifications[index];
                final bool isRead = item['isRead'] as bool;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRead ? Theme.of(context).cardColor : AppColors.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: isRead ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isRead ? Colors.grey[100] : AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: isRead ? Colors.grey : AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                if (!isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['body'] as String,
                              style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['time'] as String,
                              style: TextStyle(color: Colors.grey[400], fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
