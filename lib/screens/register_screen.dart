import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;
  bool _obscurePassword = true;

  void _register() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final error = await authService.register(
      _emailController.text.trim(),
      _passwordController.text,
      _nameController.text.trim(),
      _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (error == null) {
      _showVerificationDialog();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 8),
                Text('Verifica tu correo'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Te hemos enviado un enlace de verificacion a tu correo electronico.',
                  style: TextStyle(height: 1.4),
                ),
                const SizedBox(height: 12),
                Text(
                  _emailController.text.trim(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Por favor, verifica tu cuenta antes de iniciar sesion.',
                  style: TextStyle(height: 1.4),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: const Text('Entendido'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final theme = Theme.of(context);
    final isProcessing = _isSubmitting || authService.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear Cuenta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Icon(
                        Icons.person_add,
                        size: 48,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Crear Cuenta',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Unete a nuestra comunidad segura',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withValues(
                            alpha: 0.05,
                          ),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          AuthTextField(
                            label: 'Nombre completo',
                            icon: Icons.person,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            controller: _nameController,
                            validator: (value) {
                              final name = value?.trim() ?? '';
                              if (name.isEmpty) {
                                return 'Por favor ingresa tu nombre';
                              }
                              if (name.length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'Correo electronico',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: _emailController,
                            validator: (value) {
                              final email = value?.trim() ?? '';
                              if (email.isEmpty) {
                                return 'Por favor ingresa tu email';
                              }
                              final emailRegex = RegExp(
                                r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(email)) {
                                return 'Ingresa un email valido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'Contrasena',
                            icon: Icons.lock,
                            obscureText: _obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            enableSuggestions: false,
                            controller: _passwordController,
                            suffixIcon: IconButton(
                              tooltip:
                                  _obscurePassword
                                      ? 'Mostrar contrasena'
                                      : 'Ocultar contrasena',
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            validator: (value) {
                              final password = value ?? '';
                              if (password.isEmpty) {
                                return 'Por favor ingresa tu contrasena';
                              }
                              final passwordRegex = RegExp(
                                r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
                              );
                              if (!passwordRegex.hasMatch(password)) {
                                return 'Usa 8 caracteres, mayuscula, minuscula y numero';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          AuthTextField(
                            label: 'Celular (opcional)',
                            icon: Icons.phone,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller: _phoneController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(9),
                            ],
                            validator: (value) {
                              final phone = value?.trim() ?? '';
                              if (phone.isEmpty) return null;
                              final phoneRegex = RegExp(r'^[0-9]{9}$');
                              if (!phoneRegex.hasMatch(phone)) {
                                return 'El celular debe tener exactamente 9 digitos';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isProcessing ? null : _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child:
                                    isProcessing
                                        ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  theme.colorScheme.onPrimary,
                                                ),
                                          ),
                                        )
                                        : Text(
                                          'Crear Cuenta',
                                          style: theme.textTheme.labelLarge
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.onPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
