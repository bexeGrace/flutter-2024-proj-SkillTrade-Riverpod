import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skill_trade/admin.dart';
import 'package:skill_trade/customer.dart';
import 'package:skill_trade/models/customer.dart';
import 'package:skill_trade/models/technician.dart';
import 'package:skill_trade/presentation/screens/admin_customer.dart';
import 'package:skill_trade/presentation/screens/admin_technician.dart';
import 'package:skill_trade/presentation/screens/bookings.dart';
import 'package:skill_trade/presentation/screens/home_page.dart';
import 'package:skill_trade/presentation/screens/login_page.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';
import 'package:skill_trade/presentation/screens/technician_application_success.dart';
import 'package:skill_trade/presentation/themes.dart';
import 'package:skill_trade/riverpod/technician_provider.dart';
import 'package:skill_trade/technician.dart';
import 'package:skill_trade/riverpod/auth_provider.dart';
import 'package:go_router/go_router.dart';

void main() {
   runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      routerConfig: _router
    );
  }
}


final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const GetFirstPage(),
    ),
    GoRoute(
      path: '/admintech',
      builder: (context, state) {
          final technicianId = state.extra as int;
          return  AdminTechnician(technicianId: technicianId,);
         
        },
    ),
    GoRoute(
      path: '/admincustomer',
      builder: (context, state) {
          final customer = state.extra as Customer;
          return AdminCustomer(customer: customer);
        },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/customer',
      builder: (context, state) => CustomerPage(),
    ),
    GoRoute(
      path: '/technician',
      builder: (context, state) => TechnicianPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => AdminSite(),
    ),
    GoRoute(
      path: '/apply',
      builder: (context, state) => TechnicianApplicationSuccess(),
    ),
    GoRoute(
        path: '/myBookings',
        builder: (context, state) {
          final technician = state.extra as Technician;
          return MyBookings(technician: technician);
        },
      ),
  ],
);

class GetFirstPageLogic {
  Widget getLoggedInPage(String role) {
    switch (role) {
      case "customer":
        return const CustomerPage();
      case "technician":
        return const TechnicianPage();
      case "admin":
        return const AdminSite();
      default:
        return const HomeScreen();
    }
  }
}

class GetFirstPage extends StatelessWidget {
  const GetFirstPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer(
        builder: (context, ref, child){
          ref.read(authProvider.notifier);
          final authState = ref.watch(authProvider);

          print("main says token ${authState.token} auth ${authState.isAuthenticated}");
          
          
          if (authState.isAuthenticated) {
            return GetFirstPageLogic().getLoggedInPage(authState.role!);
          } else {
            return HomeScreen();
          }
        },
      );
  }
}