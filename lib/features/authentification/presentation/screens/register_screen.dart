import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_archives/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:my_archives/features/authentification/presentation/cubits/auth_field_cubit.dart';
import 'package:my_archives/features/code_pin_verification/presentation/screens/create_pin_code_screen.dart';
import 'package:my_archives/features/home/presentation/screens/home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CreatePinCodeScreen(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35.0),
                    child: const Text(
                      'Register',
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
                    key: AuthFieldInitial.formKey,
                    child: ListView(
                      children: [
                        _buildTextField(
                          controller: AuthFieldInitial.firstNameController,
                          hintText: "First Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (value.length > 20) {
                              return "This field is too long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: AuthFieldInitial.lastNameController,
                          hintText: "Last Name",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (value.length > 50) {
                              return "This field is too long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: AuthFieldInitial.emailController,
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
                          controller: AuthFieldInitial.passwordController,
                          hintText: "Password",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (value.length < 5) {
                              return "This field is too short";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: AuthFieldInitial.passwordConfirmController,
                          hintText: "Password Confirmation",
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "This field is required";
                            } else if (value != AuthFieldInitial.passwordController.text) {
                              return "Passwords do not match";
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
                              "Already have an account?",
                              style: TextStyle(color: Colors.white70, fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Login",
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
                              if (AuthFieldInitial.formKey.currentState?.validate() ?? false) {
                                context.read<AuthBloc>().add(
                                  RegisterClient(
                                    AuthFieldInitial.firstNameController.text,
                                    AuthFieldInitial.lastNameController.text,
                                    AuthFieldInitial.emailController.text,
                                    AuthFieldInitial.passwordController.text,
                                    AuthFieldInitial.passwordConfirmController.text,
                                    AuthFieldInitial.formKey,
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
                                : const Text("Register"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
