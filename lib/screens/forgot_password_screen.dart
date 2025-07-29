// ✅ views/forgot_password/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/cubits/forget%20password/forgot_password_cubit.dart';
import 'package:news_app/screens/login_screen.dart';
import '../../widgets/form/custom_text_form_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final answerController = TextEditingController();
  final newPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state is ForgotPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is ForgotPasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password reset successful")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  if (state is ForgotPasswordInitial || state is ForgotPasswordError) ...[
                    CustomTextFormField(
                      label: "Enter your email",
                      controller: emailController,
                      validator: (val) => val == null || val.isEmpty ? "Email is required" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().verifyEmail(
                                emailController.text.trim(),
                              );
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ] else if (state is ForgotPasswordShowSecurityQuestion) ...[
                    Text(state.question),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      label: "Your Answer",
                      controller: answerController,
                      validator: (val) => val == null || val.isEmpty ? "Answer is required" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().verifySecurityAnswer(
                                answerController.text.trim(),
                              );
                        }
                      },
                      child: const Text("Verify"),
                    ),
                  ] else if (state is ForgotPasswordSuccess) ...[
                    CustomTextFormField(
                      label: "New Password",
                      controller: newPasswordController,
                      obscureText: true,
                      validator: (val) => val == null || val.length < 6 ? "Password too short" : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<ForgotPasswordCubit>().resetPassword(
                                newPasswordController.text.trim(),
                              );
                        }
                      },
                      child: const Text("Reset Password"),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}