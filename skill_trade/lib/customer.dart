import 'package:flutter/material.dart';
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
      const CustomerBookings(),
      const CustomerProfileScreen(),
    ];
    return pages[selectedIndex];
  }
}

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerPageLogic _logic = CustomerPageLogic();
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Customer Page",
      initialRoute: "/",
      routes: {
        // "/booktech": (context) => MyBookings(),
      },
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