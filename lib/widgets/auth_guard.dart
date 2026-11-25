import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../services/auth_state.dart';

Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<AuthState>().isLoggedIn) return true;
  return await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      ) ??
      false;
}

Future<void> logoutWithFeedback(BuildContext context) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await context.read<AuthState>().logout();
    messenger.showSnackBar(const SnackBar(content: Text('Sesi berakhir.')));
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(
        content: Text('Sesi lokal berakhir. Logout di server gagal: $e'),
      ),
    );
  }
}
