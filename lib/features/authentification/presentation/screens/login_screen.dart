import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/authentification/presentation/screens/register_screen.dart';
import 'package:my_archives/features/code_pin_verification/presentation/screens/verify_pin_code_screen.dart';

import '../../../home/presentation/screens/home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../cubits/auth_field_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyArchives',
        ),
      ),
      body: _body(),
    );
  }
}

Widget _body() {
  return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthSuccess) {
        // Navigate to HomeScreen when AuthSuccess state is emitted
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerifyPinCodeScreen(),
          ),
        );
      } else if (state is AuthError) {
        // Show an error message for AuthError state
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.error)),
        );
      }
    },
    child: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthError || state is AuthLoading) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35.0),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                  // Form Section
                  Flexible(
                    child: Form(
                      key: AuthFieldLogin.formKey,
                      child: ListView(
                        children: [
                          _buildTextField(
                            controller: AuthFieldLogin.emailController,
                            hintText: "Email",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              } else if (!value.contains('@')) {
                                return "This field must be an email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: AuthFieldLogin.passwordController,
                            hintText: "Password",
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          // Login Prompt
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account yet ?",
                                style: TextStyle(color: Colors.white70, fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Submit Button
                          Center(
                            child: ElevatedButton(
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                if (AuthFieldLogin.formKey.currentState?.validate() ?? false) {
                                  context.read<AuthBloc>().add(
                                    LoginClient(
                                      AuthFieldLogin.emailController.text,
                                      AuthFieldLogin.passwordController.text,
                                      AuthFieldLogin.formKey,
                                    ),
                                  );
                                }
                              },
                              child: state is AuthLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              )
                                  : const Text("Login"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("Unexpected state. Please try again."));
      },
    ),
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
  bool isPassword = false,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    validator: validator,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white),
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white70,
          width: 1.5,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),
    ),
  );
}


