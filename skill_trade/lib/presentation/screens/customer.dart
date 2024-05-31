import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';
import 'package:skill_trade/presentation/screens/customer_profile.dart';
import 'package:skill_trade/presentation/screens/customer_bookings.dart';
import 'package:skill_trade/presentation/screens/find_technicians.dart';
import 'package:skill_trade/presentation/themes.dart';
import 'package:skill_trade/presentation/widgets/drawer.dart';


class CustomerPageLogic {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    selectedIndex = index;
  }

  Widget getCurrentPage() {
    final List<Widget> pages = [
      const FindTechnician(),
      CustomerBookings(),
      const CustomerProfileScreen(),
    ];
    return pages[selectedIndex];
  }
}

class CustomerPage extends ConsumerStatefulWidget {
  const CustomerPage({super.key});

  @override
  ConsumerState<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends ConsumerState<CustomerPage> {
  final CustomerPageLogic _logic = CustomerPageLogic();

  Future<void> loadId() async {
    String? id = await SecureStorage.instance.read("id");
    ref.read(customerNotifierProvider.notifier).loadCustomer(int.parse(id!));
    ref.read(bookingsNotifierProvider.notifier).loadCustomerBookings(int.parse(id!));
  }

    void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(techniciansNotifierProvider.notifier).loadTechnicians();

      // print()
      loadId();
  
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Customer Page",
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      home: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.menu),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            title: const Text("SkillTrade"),
            centerTitle: true,
          ),
          drawer: const MyDrawer(),
          body:  _logic.getCurrentPage(),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex:  _logic.selectedIndex,
            onTap: (index) {
              setState(() {
                _logic.navigateBottomBar(index);
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.build_outlined), label: "Find Technician"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.book_outlined), label: "My Bookings"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined), label: "My Profile"),
            ],
          ),
        ),
    );
  }
}