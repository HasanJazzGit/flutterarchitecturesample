import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../manager/auth_cubit.dart';
import '../manager/auth_state.dart';
import '../manager/state_status.dart';

// Example Login Page showing how to use AuthCubit
class LoginPageExample extends StatefulWidget {
  const LoginPageExample({super.key});

  @override
  State<LoginPageExample> createState() => _LoginPageExampleState();
}

class _LoginPageExampleState extends State<LoginPageExample> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.loginStatus == StateStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Login successful! Token: ${state.loginEntity?.token ?? ''}',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to home or next screen
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    BlocSelector<AuthCubit, AuthState, StateStatus>(
                      selector: (state) => state.loginStatus,
                      builder: (context, loginStatus) {
                        if (loginStatus == StateStatus.loading) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().loginUser(
                                context: context,
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                            }
                          },
                          child: const Text('Login'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
