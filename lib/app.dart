import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/locale_provider.dart';
import 'generated/l10n/app_localizations.dart';

class MyBookShelfApp extends ConsumerWidget {
  const MyBookShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Book Shelf',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('ur'),
        Locale('fr'),
        Locale('es'),
        Locale('tr'),
      ],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}
