import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_trade/application/providers/providers.dart';
import 'package:skill_trade/application/states/auth_state.dart';
import 'package:skill_trade/domain/models/customer.dart';
import 'package:skill_trade/domain/models/technician.dart';
import 'package:skill_trade/presentation/screens/admin.dart';
import 'package:skill_trade/presentation/screens/admin_customer.dart';
import 'package:skill_trade/presentation/screens/admin_technician.dart';
import 'package:skill_trade/presentation/screens/bookings.dart';
import 'package:skill_trade/presentation/screens/customer.dart';
import 'package:skill_trade/presentation/screens/home_page.dart';
import 'package:skill_trade/presentation/screens/login_page.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';
import 'package:skill_trade/presentation/screens/technician.dart';
import 'package:skill_trade/presentation/screens/technician_application_success.dart';
import 'package:skill_trade/presentation/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: lightMode,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
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
        return AdminTechnician(technicianId: technicianId);
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
      builder: (context, state) => const CustomerPage(),
    ),
    GoRoute(
      path: '/technician',
      builder: (context, state) => const TechnicianPage(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminSite(),
    ),
    GoRoute(
      path: '/apply',
      builder: (context, state) => const TechnicianApplicationSuccess(),
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

class GetFirstPage extends ConsumerWidget {
  const GetFirstPage({super.key});
Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return _buildPage(authState);
  }

  Widget _buildPage(AuthState authState) {
    if (authState is UnLogged) {
      return const HomeScreen();
    } else if (authState is LoggedIn) {
      return GetFirstPageLogic().getLoggedInPage(authState.role!);
    } else if (authState is SignUpState) {
      return const HomeScreen(); 
    } else if (authState is AuthError) {
      return const HomeScreen(); 
    } else if (authState is AuthSuccess) {
      return const HomeScreen(); 
    } else {
      return const SizedBox(); 
    }
  }
}