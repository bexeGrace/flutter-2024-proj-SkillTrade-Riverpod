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
          if (customer == null)
            Center(
              child: Text("There is no customer"),
            )
          else
            customerProfile(customer: customer)

<<<<<<< HEAD
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ButtonStyle(
          //         backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          //       ),
          //       child: const Text(
          //         "Suspend",
          //         style: TextStyle(
          //             color: Colors.white, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //     const SizedBox(
          //       width: 20,
          //     ),
          //     ElevatedButton(
          //       onPressed: () {},
          //       style: ButtonStyle(
          //         backgroundColor:
          //             MaterialStateProperty.all<Color>(Colors.green),
          //       ),
          //       child: const Text(
          //         "Unsuspend",
          //         style: TextStyle(
          //             color: Colors.white, fontWeight: FontWeight.w600),
          //       ),
          //     ),
          //   ],
          // ),
          // const SizedBox(
          //   height: 30,
          // ),
          // const Padding(
=======
>>>>>>> 5068cd5fad880969f9959d294fa588da732ac77a
        ],
      ),
    );
  }
}
