import 'package:flutter/material.dart';
import '../services/api_auth_service.dart';

class LoginScreen extends StatefulWidget{
  final Function(Map<String, dynamic> user, String token) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiAuthService _api = ApiAuthService();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final result = await _api.login(
        _userNameController.text.trim(),
        _passwordController.text,
      );

      // Xử lý kết quả thành công
      if (result.success && result.token != null && result.user != null) {
        widget.onLogin(result.user!, result.token!);
        if (mounted) Navigator.pop(context);
      } else {
        _showError(result.error ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      // XỬ LÝ MỌI LỖI: mạng, timeout, server, decode...
      debugPrint('Lỗi login: $e');
      _showError('Không thể kết nối. Vui lòng kiểm tra mạng và thử lại.');
    } finally {
      // ĐẢM BẢO TẮT LOADING DÙ THÀNH CÔNG HAY LỖI
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _userNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Tài khoản'),
                validator: (v) => v!.isEmpty ? 'Vui lòng nhập email' : null,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mật khẩu'),
                validator: (v) => v!.isEmpty ? 'Vui lòng nhập mật khẩu' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Đăng nhập'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
