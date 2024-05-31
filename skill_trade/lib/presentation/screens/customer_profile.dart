import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/customer_profile.dart';
import 'package:skill_trade/riverpod/customer_provider.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key});
  

  @override
  Widget build(BuildContext context, ref) {
    final asyncCustomer = ref.watch(customerProfileProvider);
    return asyncCustomer.when( 
      data: (customer){
        return customerProfile(customer: customer);
      },
      loading:() => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text("$error")),
    );
  }
}
