import 'package:mason/mason.dart';

void run(HookContext context) {
  final logger = context.logger;
  
  // Welcome message
  logger.info('🔑 Setting up Firebase Authentication Providers');
  
  // Variables are already populated by prompts defined in brick.yaml
  final selectedProviders = <String>[];
  
  if (context.vars['signup'] == true) {
    selectedProviders.add('Email Signup');
  }
  
  if (context.vars['login'] == true) {
    selectedProviders.add('Email Login');
  }
  
  if (context.vars['login_with_google'] == true) {
    selectedProviders.add('Google Login');
  }
  
  if (context.vars['login_with_apple'] == true) {
    selectedProviders.add('Apple Login');
  }
  
  if (context.vars['phone_auth'] == true) {
    selectedProviders.add('Phone Authentication');
  }
  
  if (context.vars['passwordless_email'] == true) {
    selectedProviders.add('Passwordless Email');
  }
  
  if (context.vars['forgot_password'] == true) {
    selectedProviders.add('Forgot Password');
  }
  
  if (context.vars['email_verification'] == true) {
    selectedProviders.add('Email Verification');
  }
  
  if (context.vars['change_password'] == true) {
    selectedProviders.add('Change Password');
  }
  
  // Always add these
  selectedProviders.add('Logout');
  selectedProviders.add('Delete Account');
  
  // Display selected providers
  logger.info('You selected the following authentication providers:');
  for (final provider in selectedProviders) {
    logger.info('• $provider');
  }
  
  logger.info('');
}