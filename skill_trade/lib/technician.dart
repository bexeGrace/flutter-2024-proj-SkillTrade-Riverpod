import 'package:flutter/material.dart';
import 'package:skill_trade/presentation/screens/technician_profile.dart';
import 'package:skill_trade/presentation/themes.dart';
import 'package:skill_trade/presentation/widgets/technician_booking_list.dart';
import 'package:skill_trade/presentation/widgets/drawer.dart';

class TechnicianPageLogic {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    selectedIndex = index;
  }

  Widget getCurrentPage() {
    final List<Widget> pages = [
      const TechnicianBookingList(),
      const TechnicianProfile(),
    ];
    return pages[selectedIndex];
  }
}

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key});

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  final TechnicianPageLogic _logic = TechnicianPageLogic();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Technician Page",
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          title: Text("SkillTrade"),
          centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: _logic.getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _logic.selectedIndex,
        onTap:  (index) {
          setState(() {
            _logic.navigateBottomBar(index);
          });
        },
        items:  const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "My Profile",
          ),
        ],
      ),
      ),

    );
  }
}
