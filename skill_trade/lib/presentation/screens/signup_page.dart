import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/models/customer.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/screens/customer_profile.dart';
import 'package:skill_trade/presentation/screens/login_page.dart';
import 'package:skill_trade/presentation/themes.dart';
import 'package:skill_trade/presentation/widgets/my_button.dart';
import 'package:skill_trade/presentation/widgets/my_textfield.dart';
import 'package:skill_trade/presentation/widgets/technician_application.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';
import 'package:skill_trade/riverpod/auth_provider.dart';
class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  String _user_role = "customer";
  Color _borderColor1 = Colors.blue;
  Color _borderColor2 = Colors.black;
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _bioController = TextEditingController();

  List<String> _selectedTags = [];

  List<String> _availableTags = [
    'Electricity',
    'HVAC',
    'Satelite dish',
    'Plumbing',
    'Electronics',
    'interior decoration',
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _noSkillChosen = false;

  void initState(){ 
    super.initState();
    // ref.read(authProvider.notifier);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: authState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  color: Colors.white,

                  shadowColor: Colors.black,
                  elevation: 20,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 70, 15, 70),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome to SkillTrade Hub!",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text("Customer",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: _borderColor1,
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _user_role = "customer";
                                      _borderColor1 = Colors.blue;
                                      _borderColor2 = Colors.black;
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        const AssetImage('assets/profile.jpg'),
                                    radius: 30,
                                    backgroundColor: _borderColor1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Text("Technician",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: _borderColor2,
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _user_role = "technician";
                                      _borderColor2 = Colors.blue;
                                      _borderColor1 = Colors.black;
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: const AssetImage(
                                        'assets/technician.jpg'),
                                    radius: 30,
                                    backgroundColor: _borderColor2,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        if (authState.errorMessage != null)
                        Text(
                          authState.errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                    labelText: "Fullname",
                                    prefixIcon: Icons.person_2_outlined,
                                    toggleText: false,
                                    controller: _fullNameController),
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                    labelText: "email",
                                    prefixIcon: Icons.email,
                                    toggleText: false,
                                    controller: _emailController),
                                const SizedBox(
                                  height: 15,
                                ),
                                MyTextField(
                                    labelText: "phone",
                                    prefixIcon: Icons.phone,
                                    toggleText: false,
                                    controller: _phoneController),
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
                                if (_user_role == "technician") ...[
                                  MyTextField(
                                      labelText: "Experience",
                                      prefixIcon: Icons.timelapse_sharp,
                                      toggleText: false,
                                      controller: _experienceController),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyTextField(
                                      labelText: "Education Level",
                                      prefixIcon: Icons.school,
                                      toggleText: false,
                                      controller: _educationController),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyTextField(
                                      labelText: "Available location",
                                      prefixIcon: Icons.location_city_outlined,
                                      toggleText: false,
                                      controller: _locationController),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyTextField(
                                      labelText: "Additional Bio",
                                      prefixIcon: Icons.edit,
                                      multiline: true,
                                      requiredField: false,
                                      toggleText: false,
                                      controller: _bioController),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: _noSkillChosen
                                          ? Border.all(color: Colors.red)
                                          : null,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.handyman_outlined,
                                                color: Colors.grey.shade600,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              const Text(
                                                "Skills",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                              if (_noSkillChosen) ...[
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                const Text(
                                                  "You have to choose at least one skill.",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Wrap(
                                                spacing: 5,
                                                children: _availableTags
                                                    .map(
                                                      (tag) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: InputChip(
                                                          label: Text(tag),
                                                          selected:_selectedTags.contains(tag),
                                                          onSelected:
                                                              (bool selected) {
                                                            setState(() {
                                                              if (selected) {
                                                                _selectedTags
                                                                    .add(tag);
                                                              } else {
                                                                _selectedTags.remove(tag);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_noSkillChosen) ...[]
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyButton(
                                      text: "Apply",
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (_selectedTags.length > 0) {
                                            
                                              final technician = {
                                              "fullName": _fullNameController.value.text,
                                              "role": "technician", 
                                              "skills": _selectedTags.join(", "),
                                              "email": _emailController.value.text,
                                              "phone": _phoneController.value.text,
                                              "experience": _experienceController.value.text,
                                              "availableLocation":_locationController.value.text,
                                              "password": _passwordController.value.text,
                                              "additionalBio": _bioController.value.text,
                                              "educationLevel": _educationController.value.text

                                              };
                                            await authNotifier.signup(
                                               technician
                                              );


                                           final auth = ref.watch(authProvider);
                                            print("this is authState.success ${auth.success} ");
                                            if (auth.success) {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: lightMode.primaryColorLight,
                                                  content: Text( 'Sign up successful'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: lightMode.primaryColorLight,
                                                  content: Text(auth.errorMessage ?? 'Sign up failed'),
                                                ),
                                              );
                                            }
                                            if (auth.isAuthenticated) {
                                              context.push('/technician');
                                            }
                                            
                                        

                                          } else {
                                            setState(() {
                                              _noSkillChosen = true;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  backgroundColor: lightMode.primaryColorLight,
                                                  content: const Text(
                                                      'You have to choose at least one skill.')),
                                            );
                                          }

                                        }
                                      },
                                      width: double.infinity),
                                ],
                                if (_user_role == "customer") ...[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  MyButton(
                                      text: "signup",
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final customer = {
                                            "fullName": _fullNameController.value.text, 
                                              "email": _emailController.value.text,
                                              "phone": _phoneController.value.text,
                                              "password": _passwordController.value.text,
                                              "role": "customer"
                                          };


                                              if (!authState.success)
                                                  await authNotifier.signup(customer);
                                             final auth = ref.watch(authProvider);
                                            print("this is authState.success ${auth.success} ");
                                            if (auth.success) {
                                             ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: lightMode.primaryColorLight,
                                                  content: const Text( 'Sign up successful'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text(auth.errorMessage ?? 'Sign up failed'),
                                                ),
                                              );
                                            }
                                            if (auth.isAuthenticated) {
                                              context.push('/customer');
                                            }
                                         
                                              
                                        }
                                      },
                                      width: double.infinity),
                                ],
                              ],
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Have an account?",
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(
                              width: 8,
                            ),
                            TextButton(
                                onPressed: () {
                                  context.push("/login");
                                },
                                child: Text("Login",
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
