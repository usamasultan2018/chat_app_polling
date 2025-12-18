import 'package:daily_sales_app/app/routes.dart';
import 'package:daily_sales_app/shared/widgets/app_textfield.dart';
import 'package:daily_sales_app/shared/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_sales_app/features/auth/providers/auth_provider.dart';
import 'package:daily_sales_app/core/utils/validators.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password';
    if (value != _password.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _password.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Registration successful'
              : auth.errorMessage ?? 'Registration failed',
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.userList,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(Icons.person_add_outlined, size: 80),
                  const SizedBox(height: 24),

                  AppTextField(
                    controller: _name,
                    label: 'Full Name',
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _email,
                    label: 'Email',
                    hint: 'Enter email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _password,
                    label: 'Password',
                    hint: 'Enter password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    validator: Validators.validatePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _confirmPassword,
                    label: 'Confirm Password',
                    hint: 'Re-enter password',
                    icon: Icons.lock_outline,
                    obscureText: _obscureConfirm,
                    validator: _confirmValidator,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _register(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AuthButton(
                      title: 'Register',
                      isLoading: auth.isLoading,
                      onPressed: _register,
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Already have an account? Login'),
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
