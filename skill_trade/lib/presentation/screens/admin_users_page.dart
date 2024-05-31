import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/presentation/widgets/customer_tile.dart';
import 'package:skill_trade/riverpod/customer_provider.dart';

void main() {
  runApp(const MaterialApp(
    home: CustomersList(),
  ));
}

class CustomersList extends ConsumerWidget {
  const CustomersList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final asyncCustomers = ref.watch(fetchAllCustomers);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          const Text(
            "Customers",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
          child: asyncCustomers.when( 
            data: (customers){
              return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return CustomerTile(customer: customers[index]);
                  },
                itemCount: customers.length,
                );

            },
            loading: () => Center(child: CircularProgressIndicator(),),
            error: (error, stackTrace) => Text("Customers could not be loaded. $error")
          )
          
          
         
        ),
        ],
      ),
    );
  }
}
