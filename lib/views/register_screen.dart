import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ilike/services/api_service.dart';
import 'package:ilike/views/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final response = await _apiService.post('/auth/register', {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('user', response.data['user']['_id']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } on DioException catch (e) {
        setState(() {
          _errorMessage = e.response?.data['message'] ?? "Registration failed";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 80),
                _header(),
                const SizedBox(height: 30),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                _inputField(),
                const SizedBox(height: 20),
                _registerButton(),
                const SizedBox(height: 10),
                _loginRedirect(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return const Column(
      children: [
        Text(
          "Create Account",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text("Enter your details to sign up"),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration("Name", Icons.person),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter your name";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _inputDecoration("Email", Icons.email),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Please enter your email";
            }
            if (!value.contains("@") || !value.contains(".")) {
              return "Enter a valid email address";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: _inputDecoration("Password", Icons.lock),
          validator: (value) {
            if (value == null || value.length < 6) {
              return "Password must be at least 6 characters";
            }
            return null;
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.purple.withOpacity(0.1),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _registerUser,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.purple,
      ),
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
              : const Text("Register", style: TextStyle(fontSize: 20)),
    );
  }

  Widget _loginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? "),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Login", style: TextStyle(color: Colors.purple)),
        ),
      ],
    );
  }
}
