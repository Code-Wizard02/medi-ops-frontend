// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mediops';

  @override
  String get signInTitle => 'Welcome Back';

  @override
  String get signUpTitle => 'Create Account';

  @override
  String get signInSubtitle => 'Welcome Back, Please enter Your details';

  @override
  String get signUpSubtitle => 'Sign up to get started with Mediops';

  @override
  String get signInTab => 'Sign In';

  @override
  String get signUpTab => 'Signup';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get emailHint => 'name@company.com';

  @override
  String get emailErrorEmpty => 'Enter a valid email address';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'Dr. Laura Lopez';

  @override
  String get fullNameErrorEmpty => 'Enter your full name';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get passwordErrorEmpty => 'Enter your password';

  @override
  String get passwordErrorLength => 'Password must be at least 6 characters';

  @override
  String get continueButton => 'Continue';

  @override
  String get signUpButton => 'Sign Up';

  @override
  String get registrationSuccess =>
      'Registration successful. Check your email to verify your account.';

  @override
  String get orContinueWith => 'OR CONTINUE WITH';
}
