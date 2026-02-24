class SupabaseAuthExceptionHandler {
  static String parse(dynamic error) {
    final message = error.toString();

    if (message.contains('Email not confirmed')) {
      return 'Your email is not confirmed. Please check your inbox.';
    }

    if (message.contains('Invalid login credentials')) {
      return 'Invalid Credentials. Please try again.';
    }

    if (message.contains('User already registered')) {
      return 'This email is already registered. Try logging in or using a different provider.';
    }

    if (message.contains('For security purposes')) {
      return 'Too many requests. Please wait a few seconds before trying again.';
    }

    if (message.contains('User not found')) {
      return 'No account found with that email.';
    }

    if (message.contains(
      'Password should contain at least one character of each',
    )) {
      return 'Your password must include at least one lowercase letter, one uppercase letter, one number, and one special character (like !, @, #, or \$).';
    }

    if (message.contains('missing email or phone')) {
      return 'Please fill all required fields';
    }

    return 'An unexpected error occurred. Please try again.';
  }
}