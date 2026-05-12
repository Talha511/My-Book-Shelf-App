import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Discover Your Next Favorite Book',
      description: 'Explore thousands of books from various genres and authors at your fingertips.',
      icon: Icons.explore_outlined,
    ),
    OnboardingData(
      title: 'Read Anytime, Anywhere',
      description: 'Your library follows you wherever you go. Enjoy reading on the move, even offline.',
      icon: Icons.menu_book_outlined,
    ),
    OnboardingData(
      title: 'Enable Location Services',
      description: 'Help us find nearby book fairs and libraries to enhance your reading journey.',
      icon: Icons.location_on_outlined,
      isLocationPage: true,
    ),
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_onboarding', false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPage(data: _pages[index]);
            },
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: AppColors.primary,
                    dotColor: AppColors.accent,
                    dotHeight: 8,
                    dotWidth: 8,
                    expansionFactor: 3,
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                      style: context.ts.labelMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      'Skip',
                      style: context.ts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final bool isLocationPage;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    this.isLocationPage = false,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  Future<void> _requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled. Opening settings...')),
        );
      }
      await Geolocator.openLocationSettings();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Permissions are permanently denied. Please enable them in settings.'),
          ),
        );
      }
      await Geolocator.openAppSettings();
      return;
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location Access Granted! ✅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 60),
          Text(
            data.title,
            style: context.ts.h2.copyWith(color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: context.ts.bodyMedium.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          if (data.isLocationPage) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _requestLocationPermission(context),
              icon: const Icon(Icons.my_location),
              label: const Text('Allow Access'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
