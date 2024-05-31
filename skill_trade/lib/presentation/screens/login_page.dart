import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/auth_state.dart';
import 'package:skill_trade/presentation/widgets/my_button.dart';
import 'package:skill_trade/presentation/widgets/my_textfield.dart';


class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedRole = "customer";

  @override
  void initState() {
    super.initState();
    _selectedRole = 'customer';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                // color: Colors.white,
                color: Theme.of(context).colorScheme.background,
                margin: const EdgeInsets.all(10),
                elevation: 20,
                shadowColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 70, 15, 70),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Welcome to SkillTrade Hub!",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        MyTextField(
                            labelText: "email",
                            prefixIcon: Icons.person_2_outlined,
                            suffixIcon: Icons.edit,
                            toggleText: false,
                            controller: _emailController),
                        const SizedBox(
                          height: 15,
                        ),
                        MyTextField(
                          labelText: "password",
                          prefixIcon: Icons.lock_open,
                          suffixIcon: Icons.remove_red_eye_rounded,
                          toggleText: true,
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'customer',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const Text('Customer'),
                            Radio<String>(
                              value: 'technician',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const Text('Technician'),
                            Radio<String>(
                              value: 'admin',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value!;
                                });
                              },
                            ),
                            const Text('Admin'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyButton(
                            text: "login",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final authNotifier = ref.read(authNotifierProvider.notifier);
                                await authNotifier.logIn(
                                  _selectedRole,
                                  _emailController.text,
                                  _passwordController.text,
                                );
                                final authState = ref.read(authNotifierProvider);

                                if (authState is AuthError) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(authState.error),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text( 'Successfully logged in!'),
                                    ),
                                  );
                                  GoRouter.of(context).go('/');
                                }
                              }
                            },
                            width: double.infinity),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?",
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(
                              width: 8,
                            ),
                            TextButton(
                                onPressed: () {
                                  context.go("/signup");
                                },
                                child: Text("Sign up",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.purple.shade300)))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  

}