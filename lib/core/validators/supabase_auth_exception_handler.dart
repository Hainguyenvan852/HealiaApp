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
      return 'No account found with that email';
    }

    if (message.contains(
      'Password should contain at least one character of each',
    )) {
      return 'Your password must include at least one lowercase letter, one uppercase letter, one number, and one special character (like !, @, #, or \$).';
    }

    if (message.contains('missing email or phone')) {
      return 'Please fill all required fields';
    }

    if (message.contains('token has expired or invalid')) {
      return 'Token has expired or invalid';
    }

    if (message.contains('Failed to sign in with Google')) {
      return 'Failed to sign in with Google';
    }

    if (message.contains('Facebook login failed: LoginStatus.cancelled')) {
      return 'Failed to sign in with Facebook';
    }

    if (message.contains('Bad ID token')) {
      return 'Failed to sign in: Bad ID token';
    }

    if (message.contains(
      'New password should be different from the old password',
    )) {
      return 'New password should be different from the old password';
    }

    if (message.contains('Error confirming user')) {
      return 'Error confirming user. Please try again';
    }

    if (message.contains('Error sending recovery email')) {
      return 'Your account does not exist, or you have logged in using a different method';
    }

    return message;
  }
}
