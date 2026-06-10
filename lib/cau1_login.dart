import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _studentIdController = TextEditingController();
  final _supabase = Supabase.instance.client;
  bool _isLoading = false;
  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final data = await _supabase
          .from('sinhvien')
          .select()
          .eq('masv', _studentIdController.text.trim())
          .maybeSingle();

      if (data != null) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ma sinh vien khong hop le, vui long kiem tra lai!'),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _studentIdController,
              decoration: const InputDecoration(labelText: 'Ma so sinh vien.'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Dang nhap'),
                  ),
          ],
        ),
      ),
    );
  }
}
