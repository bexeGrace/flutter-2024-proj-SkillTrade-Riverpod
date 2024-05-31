import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:skill_trade/main.dart';
import 'package:skill_trade/presentation/screens/home_page.dart';
import 'package:skill_trade/presentation/screens/login_page.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';
import 'package:skill_trade/presentation/widgets/technician_application.dart';
import 'package:skill_trade/technician.dart';

// class MockAuthBloc extends Mock implements AuthBloc {}
void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();


  group('Technician Signup', () {
    testWidgets('Technician Signup', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify that HomeScreen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('SkillTrade Hub'), findsOneWidget);

      // Tap the signup button
      final signupButtonFinder = find.text('signup');
      await tester.ensureVisible(signupButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(signupButtonFinder);
      await tester.pumpAndSettle();

      // Verify that SignupPage is displayed
      expect(find.byType(SignupPage), findsOneWidget);

      final technicianAvatarFinder = find.byWidgetPredicate(
        (Widget widget) =>
            widget is CircleAvatar &&
            (widget.backgroundImage as AssetImage).assetName ==
                'assets/technician.jpg',
      );
      await tester.tap(technicianAvatarFinder);
      await tester.pumpAndSettle();

      // Enter full name
      await tester.enterText(find.bySemanticsLabel('Fullname'), 'Jane Smith');
      // Enter email
      await tester.enterText(
          find.bySemanticsLabel('email'), 'jane.smith@example.com');
      // Enter phone
      await tester.enterText(find.bySemanticsLabel('phone'), '0987654321');
      // Enter password
      await tester.enterText(find.bySemanticsLabel('password'), 'password123');
      // Enter experience
      await tester.enterText(find.bySemanticsLabel('Experience'), '5 years');
      // Enter education level
      await tester.enterText(
          find.bySemanticsLabel('Education Level'), 'Bachelor\'s Degree');
      // Enter location
      await tester.enterText(
          find.bySemanticsLabel('Available location'), 'New York');
      // Enter bio
      await tester.enterText(find.bySemanticsLabel('Additional Bio'),
          'Experienced technician with expertise in HVAC.');
      // Select skills
      final skill1 = find.text('Electricity');
      final skill2 = find.text('Plumbing');

      await tester.ensureVisible(skill1);
      await tester.tap(skill1);
      await tester.pumpAndSettle();

      await tester.ensureVisible(skill2);
      await tester.tap(skill2);
      await tester.pumpAndSettle();

      // Dismiss the keyboard
      await tester.tapAt(Offset(0, 0));
      await tester.pumpAndSettle();

      // Scroll the signup button into view
      final signupButtonFinderForm = find.text('Apply');
      await tester.ensureVisible(signupButtonFinderForm);
      await tester.pumpAndSettle();

      // Tap the signup button
      await tester.tap(signupButtonFinderForm);

      // Wait for backend response and app to settle
      await tester.pumpAndSettle();

      // Verify that TechnicianPage is displayed after signup
      expect(await find.byType(TechnicianApplication), findsOneWidget);
    });
  });
  group('Technician Login Tests', () {
    testWidgets('Technician Login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      // Wait for the app to settle
      await tester.pumpAndSettle();

      // Verify that HomeScreen is displayed
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('SkillTrade Hub'), findsOneWidget);

      // Tap the login button
      final loginButtonFinder = find.text('Login');
      await tester.ensureVisible(loginButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      // Verify that LoginPage is displayed
      expect(find.byType(LoginPage), findsOneWidget);

      // Enter email
      await tester.enterText(
          find.bySemanticsLabel('email'), 'jane.smith@example.com');
      // Enter password
      await tester.enterText(find.bySemanticsLabel('password'), 'password123');
      await tester.pumpAndSettle();

      final technicianRadioFinder = find.text('Technician').hitTestable();
      await tester.tap(technicianRadioFinder);
      await tester.pumpAndSettle();

      // Scroll the login button into view
      final loginButtonFinderForm = find.text('login');
      await tester.ensureVisible(loginButtonFinderForm);
      await tester.pumpAndSettle();

      // Tap the login button
      await tester.tap(loginButtonFinderForm);

      // Wait for backend response and app to settle
      await tester.pumpAndSettle();

      // Verify that TechnicianPage is displayed after login
      expect(await find.byType(TechnicianPage), findsOneWidget);



      // Tap to open the drawer
      final openDrawerIcon = find.byIcon(Icons.menu); 
      await tester.ensureVisible(openDrawerIcon);
      // Assuming the menu icon opens the drawer
      await tester.tap(openDrawerIcon);

      await tester.pumpAndSettle();

      // Tap the logout option
      final logoutOptionFinder = find.text('Logout');
      await tester.ensureVisible(logoutOptionFinder);
      await tester.tap(logoutOptionFinder);
      await tester.pumpAndSettle();

      // Verify that HomeScreen is displayed again after logout
      expect(await find.byType(HomeScreen), findsOneWidget);
    });
  }, skip: "skip for now");
}
