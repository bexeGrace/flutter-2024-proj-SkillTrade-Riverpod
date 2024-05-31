import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/presentation/widgets/customer_profile.dart';

class CustomerProfileScreen extends ConsumerStatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  ConsumerState<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends ConsumerState<CustomerProfileScreen> {


  bool changePassword = false;
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  void initState(){
    
  }

  @override
  Widget build(BuildContext context) {
    
    final customerState = ref.watch(customerNotifierProvider);

    if (customerState is CustomerLoaded) {
            return ListView(
              children: [
                customerProfile(customer: customerState.customer,),
                const SizedBox(height: 35,),
                changePassword? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      TextField(
                       controller: oldPasswordController,
                       decoration: const InputDecoration(
                          hintText: 'Enter old password',
                          border: OutlineInputBorder(),
                        ), 
                        obscureText: true,
                      ),
                      const SizedBox(height: 15,),
                      TextField(
                       controller: newPasswordController,
                       decoration: const InputDecoration(
                          hintText: 'Enter new password',
                          border: OutlineInputBorder(),
                        ), 
                        obscureText: true,
                      ),
                    ],
                  ),
                ): const SizedBox(),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (changePassword && oldPasswordController.text != "" && newPasswordController.text != "") {
                          updatePassword(customerState.customer.id);
                        }
                        changePassword = !changePassword;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(changePassword? "Save Changes": "Change Password", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            );
          } else if (customerState is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (customerState is CustomerError) {
            return Center(child: Text(customerState.error));
          } else {
            return Container();
          }
        
  }
  
  void updatePassword(id) {
    ref.read(customerNotifierProvider.notifier).updatePassword(role: 'customer', id: id, oldPassword: oldPasswordController.text, newPassword: newPasswordController.text);
    oldPasswordController.clear();
    newPasswordController.clear();
  }
}