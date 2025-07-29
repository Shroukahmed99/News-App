// views/register/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/screens/login_screen.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../cubits/auth/auth_state.dart';
import '../../widgets/form/custom_text_form_field.dart';
import '../../widgets/form/password_form_field.dart';
import '../../widgets/form/custom_button.dart';
import '../../utils/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final securityQuestionController = TextEditingController();
  final securityAnswerController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    securityQuestionController.dispose();
    securityAnswerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registration successful")),
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
              child: ListView(
                children: [
                  CustomTextFormField(
                    label: "First Name",
                    controller: firstNameController,
                    validator: ValidationUtils.validateName,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Last Name",
                    controller: lastNameController,
                    validator: ValidationUtils.validateName,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: ValidationUtils.validateEmail,
                  ),
                  const SizedBox(height: 10),
                  PasswordFormField(
                    controller: passwordController,
                    label: "Password",
                    validator: ValidationUtils.validatePassword,
                  ),
                  const SizedBox(height: 10),
                  PasswordFormField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    validator: (val) => ValidationUtils.validateConfirmPassword(
                      val,
                      passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Security Question",
                    controller: securityQuestionController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Security question is required"
                        : null,
                  ),
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    label: "Security Answer",
                    controller: securityAnswerController,
                    validator: (val) => val == null || val.isEmpty
                        ? "Answer is required"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Register",
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthCubit>().register(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              securityQuestion:
                                  securityQuestionController.text.trim(),
                              securityAnswer:
                                  securityAnswerController.text.trim(),
                            );
                      }
                    },
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
