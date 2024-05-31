import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/infrastructure/storage/storage.dart';
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
      TechnicianBookingList(),
      const TechnicianProfile(),
    ];
    return pages[selectedIndex];
  }
}

class TechnicianPage extends ConsumerStatefulWidget {
  const TechnicianPage({super.key});

  @override
  ConsumerState<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends ConsumerState<TechnicianPage> {
  final TechnicianPageLogic _logic = TechnicianPageLogic();

  Future<void> loadId() async {
    String? id = await SecureStorage.instance.read("id");
    ref.read(individualTechnicianNotifierProvider.notifier).loadIndividualTechnician(int.parse(id!));

    ref.read(bookingsNotifierProvider.notifier).loadTechnicianBookings(int.parse(id!));
    ref.read(reviewsNotifierProvider.notifier).loadTechnicianReviews(int.parse(id!));

  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // print()
      loadId();
  
    });
  }

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
