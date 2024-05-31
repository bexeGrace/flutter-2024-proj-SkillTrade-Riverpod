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

      await tester.enterText(find.bySemanticsLabel('Fullname'), 'Jane Smith');
      await tester.enterText(
          find.bySemanticsLabel('email'), 'jane.smith@example.com');
      await tester.enterText(find.bySemanticsLabel('phone'), '0987654321');

      await tester.enterText(find.bySemanticsLabel('password'), 'password123');
      await tester.enterText(find.bySemanticsLabel('Experience'), '5 years');

      await tester.enterText(
          find.bySemanticsLabel('Education Level'), 'Bachelor\'s Degree');

      await tester.enterText(
          find.bySemanticsLabel('Available location'), 'New York');

      await tester.enterText(find.bySemanticsLabel('Additional Bio'),
          'Experienced technician with expertise in HVAC.');

      final skill1 = find.text('Electricity');
      final skill2 = find.text('Plumbing');

      await tester.ensureVisible(skill1);
      await tester.tap(skill1);
      await tester.pumpAndSettle();

      await tester.ensureVisible(skill2);
      await tester.tap(skill2);
      await tester.pumpAndSettle();

      await tester.tapAt(Offset(0, 0));
      await tester.pumpAndSettle();

      final signupButtonFinderForm = find.text('Apply');
      await tester.ensureVisible(signupButtonFinderForm);
      await tester.pumpAndSettle();

      await tester.tap(signupButtonFinderForm);

      await tester.pumpAndSettle();

      expect(await find.byType(TechnicianApplication), findsOneWidget);
    });
  });
  group('Technician Login Tests', () {
    testWidgets('Technician Login', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('SkillTrade Hub'), findsOneWidget);

      final loginButtonFinder = find.text('Login');
      await tester.ensureVisible(loginButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);

      await tester.enterText( find.bySemanticsLabel('email'), 'jane.smith@example.com');
      await tester.enterText(find.bySemanticsLabel('password'), 'password123');
      await tester.pumpAndSettle();

      final technicianRadioFinder = find.text('Technician').hitTestable();
      await tester.tap(technicianRadioFinder);
      await tester.pumpAndSettle();

      final loginButtonFinderForm = find.text('login');
      await tester.ensureVisible(loginButtonFinderForm);
      await tester.pumpAndSettle();

 
      await tester.tap(loginButtonFinderForm);

      await tester.pumpAndSettle();

      expect(await find.byType(TechnicianPage), findsOneWidget);

      final openDrawerIcon = find.byIcon(Icons.menu); 
      await tester.ensureVisible(openDrawerIcon);

      await tester.tap(openDrawerIcon);

      await tester.pumpAndSettle();

      final logoutOptionFinder = find.text('Logout');
      await tester.ensureVisible(logoutOptionFinder);
      await tester.tap(logoutOptionFinder);
      await tester.pumpAndSettle();

      expect(await find.byType(HomeScreen), findsOneWidget);
    });
  }, skip: "skip for now");
}
