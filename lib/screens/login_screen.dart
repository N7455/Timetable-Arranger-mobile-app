import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool signup = false;
  bool loading = false;

  Future<void> submit() async {
    setState(() => loading = true);
    try {
      if (signup) {
        await AuthService().signUp(email.text, password.text);
      } else {
        await AuthService().signIn(email.text, password.text);
      }
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Column(
                children: [
                  const Icon(Icons.calendar_month, size: 80, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  const Text('Timetable Arranger',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(signup ? 'Create your account' : 'Login to continue',
                      style: const TextStyle(color: Colors.white60)),
                  const SizedBox(height: 30),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: loading ? null : submit,
                      child: loading
                          ? const CircularProgressIndicator()
                          : Text(signup ? 'Create Account' : 'Login'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => signup = !signup),
                    child: Text(signup
                        ? 'Already have an account? Login'
                        : 'Create a new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
