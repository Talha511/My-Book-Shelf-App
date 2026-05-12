import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ReadingHistoryScreen extends StatefulWidget {
  const ReadingHistoryScreen({super.key});

  @override
  State<ReadingHistoryScreen> createState() => _ReadingHistoryScreenState();
}

class _ReadingHistoryScreenState extends State<ReadingHistoryScreen> {
  // Dummy data moved to state
  final List<Map<String, dynamic>> _history = [
    {'title': 'The Midnight Library', 'author': 'Matt Haig', 'progress': 0.65, 'lastRead': '2 hours ago'},
    {'title': 'Atomic Habits', 'author': 'James Clear', 'progress': 0.32, 'lastRead': 'Yesterday'},
    {'title': 'Peer-e-Kamil', 'author': 'Umera Ahmed', 'progress': 1.0, 'lastRead': '3 days ago'},
    {'title': 'Dune', 'author': 'Frank Herbert', 'progress': 0.15, 'lastRead': '1 week ago'},
  ];

  void _removeItem(int index) {
    setState(() {
      _history.removeAt(index);
    });
  }

  void _clearAll() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Clear History',
      text: 'Are you sure you want to delete all reading history?',
      confirmBtnText: 'Yes, Clear All',
      cancelBtnText: 'No, Cancel',
      confirmBtnColor: Colors.redAccent,
      onConfirmBtnTap: () async {
        setState(() => _history.clear());
        Navigator.pop(context);
        
        await Future.delayed(const Duration(milliseconds: 300));
        
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Cleared!',
            text: 'History has been deleted successfully.',
            confirmBtnColor: AppColors.primary,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading History'),
        centerTitle: true,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
              onPressed: _clearAll,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: _history.isEmpty 
        ? _buildEmptyState(context)
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _history.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = _history[index];
              final double progress = item['progress'] as double;
              
              return Dismissible(
                key: Key(item['title'] as String),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  bool confirm = false;
                  await QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    title: 'Remove Item',
                    text: 'Do you want to remove this book from history?',
                    confirmBtnText: 'Remove',
                    cancelBtnText: 'Keep',
                    confirmBtnColor: Colors.redAccent,
                    onConfirmBtnTap: () {
                      confirm = true;
                      Navigator.pop(context);
                    },
                  );
                  return confirm;
                },
                onDismissed: (direction) {
                  _removeItem(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Book removed from history'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.redAccent),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 70,
                          height: 90,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.book_outlined, color: AppColors.primary, size: 30),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String, 
                              style: context.ts.h3.copyWith(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              item['author'] as String, 
                              style: context.ts.bodySmall.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Stack(
                              children: [
                                Container(
                                  height: 6,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: progress,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.primary,
                                          Color(0xFF5A6B3E),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${(progress * 100).toInt()}% Done', 
                                  style: context.ts.bodySmall.copyWith(
                                    color: AppColors.primary, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['lastRead'] as String, 
                                      style: context.ts.bodySmall.copyWith(fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text('No History Yet', style: context.ts.h3),
          const SizedBox(height: 8),
          Text('Books you read will appear here', style: context.ts.bodySmall),
        ],
      ),
    );
  }
}
