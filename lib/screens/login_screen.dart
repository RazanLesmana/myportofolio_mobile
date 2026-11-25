import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '', password = '';
  bool busy = false;
  Future<void> _submit() async {
    if (busy || !_formKey.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await context.read<AuthState>().login(username.trim(), password);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login gagal: $e')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Login')),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Username'),
            onChanged: (v) => username = v,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Masukkan username' : null,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (v) => password = v,
            validator: (v) =>
                v == null || v.isEmpty ? 'Masukkan password' : null,
          ),
          ElevatedButton(
            onPressed: busy ? null : _submit,
            child: busy
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
        ],
      ),
    ),
  );
}
