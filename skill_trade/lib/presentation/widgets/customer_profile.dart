import 'package:flutter/material.dart';
import 'package:skill_trade/models/customer.dart';
import 'package:skill_trade/presentation/widgets/info_label.dart';

class customerProfile extends StatelessWidget {
  final Customer customer;
  const customerProfile({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage("assets/profile.jpg"),
            ),
            const SizedBox(height: 10),
            InfoLabel(
              label: "Name",
              data: customer.fullName,
            ),
            InfoLabel(label: "Email", data: customer.email),
            InfoLabel(label: "Phone", data: customer.phone),
          ],
        )));
  }
}
