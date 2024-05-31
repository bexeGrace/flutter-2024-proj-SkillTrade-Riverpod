import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/customer_state.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/presentation/widgets/customer_tile.dart';

class CustomersList extends ConsumerWidget {
  const CustomersList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final customersState = ref.watch(customerNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: Text(
              "Customers",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          ),
        ),
        Expanded(
          child: Consumer( 
            builder: ((context, ref, child) {
              if (customersState is CustomerLoading){
                      return const Center(child: CircularProgressIndicator());
                    } else if (customersState is AllCustomersLoaded) {
                      final List<Customer> customers= customersState.customers;
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return CustomerTile(customer: customers[index]);
                        },
                      itemCount: customers.length,
                      );
                    } else if (customersState is CustomerError) {
                      return Center(child: Text(customersState.error));
                    } else {
                      return Container();
                    }
            }),
          )
        ),
      ],
    );
  }
}