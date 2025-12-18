import 'package:daily_sales_app/shared/widgets/app_textfield.dart';
import 'package:daily_sales_app/shared/widgets/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:daily_sales_app/features/auth/providers/auth_provider.dart';
import 'package:daily_sales_app/core/utils/validators.dart';
import 'package:daily_sales_app/app/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      email: _email.text.trim(),
      password: _password.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, AppRoutes.userList);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 80),
                const SizedBox(height: 24),

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
                  obscureText: _obscure,
                  validator: Validators.validatePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: AuthButton(
                    title: 'Login',
                    isLoading: auth.isLoading,
                    onPressed: _login,
                  ),
                ),

                const SizedBox(height: 16),

                // 🔹 Create account section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    TextButton(
                      onPressed: auth.isLoading
                          ? null
                          : () {
                              Navigator.pushNamed(context, AppRoutes.register);
                            },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
