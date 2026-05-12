import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Wrap any screen's body with [AppLoader] to show a themed overlay while loading.
/// Usage:
///   AppLoader(
///     isLoading: _isLoading,
///     child: YourWidget(),
///   )
class AppLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoader({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.6),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF252D18) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? AppColors.accent : AppColors.primary,
                          ),
                          backgroundColor: (isDark ? AppColors.accent : AppColors.primary)
                              .withValues(alpha: 0.15),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Please wait...',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.accent : AppColors.primary,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Inline small loader — use inside buttons or small spaces
class AppInlineLoader extends StatelessWidget {
  final Color? color;
  const AppInlineLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? (isDark ? AppColors.accent : Colors.white),
        ),
      ),
    );
  }
}
