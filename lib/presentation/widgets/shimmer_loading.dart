import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF252D18) : Colors.grey[300]!,
      highlightColor: isDark ? const Color(0xFF3A4A28) : Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF252D18) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover placeholder
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF2E3A1E)
                          : Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                    ),
                  ),
                ),
                // Text placeholders
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2E3A1E)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 10,
                        width: 80,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2E3A1E)
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: List.generate(
                          5,
                          (_) => Container(
                            margin: const EdgeInsets.only(right: 3),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.secondary.withValues(alpha: 0.3)
                                  : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
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
