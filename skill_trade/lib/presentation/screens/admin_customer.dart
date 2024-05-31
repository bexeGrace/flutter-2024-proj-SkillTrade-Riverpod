import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/presentation/widgets/customer_profile.dart';

class AdminCustomer extends ConsumerWidget {
  final Customer customer;
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
          customerProfile(customer: customer)
        ],
      ),
    );
  }
}
