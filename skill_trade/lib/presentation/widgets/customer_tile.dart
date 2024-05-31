import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/models/customer.dart';
import 'package:skill_trade/presentation/screens/admin_customer.dart';

class CustomerTile extends StatelessWidget {
  final Customer customer;
  const CustomerTile ({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset("assets/customer.png"),
          ),
          title: Text("${customer.fullName}", style: TextStyle(fontWeight: FontWeight.w500),),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${customer.email}"),
              Text("tel: ${customer.phone}"),
            ],
          ),
          trailing: TextButton(
            onPressed: () {
              context.push('/admincustomer', extra: customer);
            },
            child: const Text("Review")
          ),
        ),
      );
  }
}