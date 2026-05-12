import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('tr'),
    Locale('ur')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MyBookShelf'**
  String get appTitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinMyBookShelf.
  ///
  /// In en, this message translates to:
  /// **'Join MyBookShelf'**
  String get joinMyBookShelf;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account to start reading'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get fullNameHint;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Min. 6 characters'**
  String get passwordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @agreeTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeTerms;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @agreeToTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please agree to Terms & Conditions'**
  String get agreeToTermsError;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Account created! Please login.'**
  String get accountCreated;

  /// No description provided for @addBook.
  ///
  /// In en, this message translates to:
  /// **'Add New Book'**
  String get addBook;

  /// No description provided for @bookTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Title'**
  String get bookTitle;

  /// No description provided for @bookTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter book title'**
  String get bookTitleHint;

  /// No description provided for @bookTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Book title is required'**
  String get bookTitleRequired;

  /// No description provided for @bookAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get bookAuthor;

  /// No description provided for @bookAuthorHint.
  ///
  /// In en, this message translates to:
  /// **'Enter author name'**
  String get bookAuthorHint;

  /// No description provided for @bookAuthorRequired.
  ///
  /// In en, this message translates to:
  /// **'Author name is required'**
  String get bookAuthorRequired;

  /// No description provided for @bookCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get bookCategory;

  /// No description provided for @bookCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Fiction, Self-Help, Tech'**
  String get bookCategoryHint;

  /// No description provided for @bookDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get bookDescription;

  /// No description provided for @bookDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short description...'**
  String get bookDescriptionHint;

  /// No description provided for @bookDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get bookDescriptionRequired;

  /// No description provided for @bookCover.
  ///
  /// In en, this message translates to:
  /// **'Book Cover'**
  String get bookCover;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Gallery'**
  String get pickFromGallery;

  /// No description provided for @pickFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Pick from Camera'**
  String get pickFromCamera;

  /// No description provided for @uploadBook.
  ///
  /// In en, this message translates to:
  /// **'Upload Book'**
  String get uploadBook;

  /// No description provided for @uploadBookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share a book with the community'**
  String get uploadBookSubtitle;

  /// No description provided for @uploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Book uploaded successfully!'**
  String get uploadSuccess;

  /// No description provided for @uploadSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your book is now available in the library.'**
  String get uploadSuccessSubtitle;

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Upload failed. Please try again.'**
  String get uploadError;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @bookAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Book has been added to your library.'**
  String get bookAddedSuccess;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @helloReader.
  ///
  /// In en, this message translates to:
  /// **'Hello, Reader!'**
  String get helloReader;

  /// No description provided for @findNextStory.
  ///
  /// In en, this message translates to:
  /// **'Find Your Next Story'**
  String get findNextStory;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search books, authors, categories...'**
  String get searchHint;

  /// No description provided for @noBooks.
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get noBooks;

  /// No description provided for @noBooksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or category'**
  String get noBooksSubtitle;

  /// No description provided for @readingHistory.
  ///
  /// In en, this message translates to:
  /// **'Reading History'**
  String get readingHistory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @accountDetails.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since'**
  String get memberSince;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @editAccountSettings.
  ///
  /// In en, this message translates to:
  /// **'Edit Account Settings'**
  String get editAccountSettings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @profileImageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile image updated successfully'**
  String get profileImageUpdated;

  /// No description provided for @passwordProtectionHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password to protect your account'**
  String get passwordProtectionHint;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account to continue'**
  String get signInSubtitle;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'en',
        'es',
        'fr',
        'tr',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
