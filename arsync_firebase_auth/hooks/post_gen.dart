import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final logger = context.logger;

  // Count how many providers were generated
  final selectedProviders = <String>[];

  if (context.vars['signup'] == true) {
    selectedProviders.add('Email Signup (sign_up_provider.dart)');
  }

  if (context.vars['login'] == true) {
    selectedProviders.add('Email Login (login_with_email_provider.dart)');
  }

  if (context.vars['login_with_google'] == true) {
    selectedProviders.add('Google Login (login_with_google_provider.dart)');
  }

  if (context.vars['login_with_apple'] == true) {
    selectedProviders.add('Apple Login (login_with_apple_provider.dart)');
  }

  if (context.vars['phone_auth'] == true) {
    selectedProviders.add(
      'Phone Authentication (login_with_phone_provider.dart)',
    );
  }

  if (context.vars['passwordless_email'] == true) {
    selectedProviders.add(
      'Passwordless Email (passwordless_email_provider.dart)',
    );
  }

  if (context.vars['forgot_password'] == true) {
    selectedProviders.add('Forgot Password (forgot_password_provider.dart)');
  }

  if (context.vars['email_verification'] == true) {
    selectedProviders.add('Email Verification (verify_email_provider.dart)');
  }

  if (context.vars['change_password'] == true) {
    selectedProviders.add('Change Password (change_password_provider.dart)');
  }

  // Always add these
  selectedProviders.add('Logout (log_out_provider.dart)');
  selectedProviders.add('Delete Account (delete_account_provider.dart)');
  selectedProviders.add('Auth Base Notifier (auth_base_notifier.dart)');
  selectedProviders.add('Auth Loading Provider (auth_loading_provider.dart)');

  // Summary message
  logger.success('🎉 Authentication providers generated successfully!');
  logger.info('Generated ${selectedProviders.length} files:');

  for (final provider in selectedProviders) {
    logger.info('• $provider');
  }

  // Install required packages
  logger.info('\n📦 Installing required packages...');

  // Core packages - always install these
  final corePackages = [
    'firebase_auth',
    'cloud_firestore',
    'firebase_messaging',
    'flutter_local_notifications',
  ];

  // Conditional packages
  final conditionalPackages = <String>[];

  if (context.vars['login_with_google'] == true) {
    conditionalPackages.add('google_sign_in');
  }

  if (context.vars['login_with_apple'] == true) {
    conditionalPackages.add('sign_in_with_apple');
  }

  // Combine all packages
  final allPackages = [...corePackages, ...conditionalPackages];

  // Install packages
  final progress = logger.progress('Installing packages');
  try {
    for (final package in allPackages) {
      progress.update('Installing $package');
      final result = await Process.run('flutter', [
        'pub',
        'add',
        package,
      ], runInShell: true);

      if (result.exitCode != 0) {
        logger.err('Failed to install $package: ${result.stderr}');
      }
    }
    progress.complete('Packages installed successfully!');
  } catch (e) {
    progress.fail('Failed to install packages: $e');
    logger.err('Error installing packages: $e');
    logger.info('You may need to install packages manually:');
    for (final package in allPackages) {
      logger.info('• $package');
    }
  }
}
