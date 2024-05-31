import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/customer_profile.dart';

class AdminCustomer extends ConsumerWidget {
  final customer;
  const AdminCustomer({super.key, required this.customer});

  @override
  Widget build(BuildContext context, ref) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          if(customer == null)
            Center(child: Text("There is no customer"),)
          else
          customerProfile(customer: customer)

        ],
      ),
    );
  }
}