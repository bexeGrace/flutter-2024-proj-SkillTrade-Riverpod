import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/presentation/screens/customer_profile.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';
import 'package:skill_trade/presentation/widgets/my_button.dart';
import 'package:skill_trade/presentation/widgets/my_textfield.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';
import 'package:skill_trade/riverpod/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedRole = "Customer";

  @override
  void initState() {
    super.initState();
    _selectedRole = 'Customer';
    // ref.read(authProvider.notifier)._loadToken();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: authState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                        if (authState.errorMessage != null)
                        Text(
                          authState.errorMessage!,
                          style: TextStyle(color: Colors.red),
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
                          // mainAxisAlignment: MainAxisAlignment.,
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
                            // SizedBox(width: 15,),
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
                            // SizedBox(width: 15,),
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
                            onPressed: ()async {
                              if (_formKey.currentState!.validate()) {
                                await ref.read(authProvider.notifier).signin(_selectedRole, _emailController.text, _passwordController.text);
                                final auth = ref.watch(authProvider);
                                if (auth.isAuthenticated){
                                  if (auth.role == "customer"){ 
                                    context.push(
                                      "/customer");
                                  } else if (auth.role == "technician"){ 
                                    context.push(
                                      "/technician");

                                  } else if(auth.role == "admin"){ 
                                    context.push(
                                      "/admin");
                                  }
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
                                  context.push("/signup");
                                },
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.purple.shade300
                                  )
                                )
                              )
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
