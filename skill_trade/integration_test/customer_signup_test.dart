import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:skill_trade/customer.dart';
import 'package:skill_trade/main.dart';

import 'package:skill_trade/presentation/screens/home_page.dart';
import 'package:skill_trade/presentation/screens/signup_page.dart';

// class MockAuthBloc extends Mock implements AuthBloc {}
void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(
    'Customer Signup',
    () {
      testWidgets('Signup flow', (WidgetTester tester) async {
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle(); // Wait for the app to settle

        // Verify that HomeScreen is displayed
        expect(find.byType(HomeScreen), findsOneWidget);
        expect(find.text('SkillTrade Hub'), findsOneWidget);

        // Navigate to the signup page
        final signupButtonFinder = find.text('Sign up');
        await tester.ensureVisible(signupButtonFinder);
        await tester.tap(signupButtonFinder);
        await tester.pumpAndSettle();
        expect(find.byType(SignupPage), findsOneWidget);

        // Enter full name
        await tester.enterText(find.bySemanticsLabel('Fullname'), 'John Doe');
        // Enter email
        await tester.enterText(
            find.bySemanticsLabel('email'), 'john.doe@example.com');
        // Enter phone
        await tester.enterText(find.bySemanticsLabel('phone'), '1234567890');
        // Enter password
        await tester.enterText(
            find.bySemanticsLabel('password'), 'password123');

        // Dismiss the keyboard
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Tap the signup button
        final signupButtonFinderForm = find.text('signup');
        await tester.ensureVisible(signupButtonFinderForm);
        await tester.tap(signupButtonFinderForm);
        await tester.pumpAndSettle();

        // Verify navigation to CustomerPage
        expect(await find.byType(CustomerPage), findsOneWidget);

        final openDrawerIcon = find.byIcon(Icons.menu);
        await tester.ensureVisible(openDrawerIcon);

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
    },
  );
}
