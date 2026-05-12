import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Use [context.ts] to get theme-aware text styles.
/// e.g. Text('Hello', style: context.ts.h2)
extension TextStylesX on BuildContext {
  _AppTextStyles get ts => _AppTextStyles(this);
}

class _AppTextStyles {
  final BuildContext context;
  _AppTextStyles(this.context);

  Color get _primary => Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary;
  Color get _secondary => Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary;

  TextStyle get h1 => GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: _primary, letterSpacing: -0.5);
  TextStyle get h2 => GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: _primary, letterSpacing: -0.5);
  TextStyle get h3 => GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: _primary);
  TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, color: _primary);
  TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, color: _primary);
  TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, color: _secondary);
  TextStyle get labelMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _secondary);
}

/// Static fallback — use only where no BuildContext is available (e.g. theme definitions).
class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5);
  static TextStyle get h2 => GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.5);
  static TextStyle get h3 => GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary);
  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary);
  static TextStyle get bodyMedium => GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary);
  static TextStyle get bodySmall => GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary);
  static TextStyle get labelMedium => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary);
}
