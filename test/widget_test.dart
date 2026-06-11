import 'package:flutter_test/flutter_test.dart';
import 'package:kupkop/main.dart';

void main() {
  testWidgets('shows the KUPKOP welcome screen', (tester) async {
    await tester.pumpWidget(const KupkopApp());

    expect(find.bySemanticsLabel('KupKop'), findsOneWidget);
    expect(find.text('An app to care for your love ones'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
    expect(find.text('I ALREADY HAVE AN ACCOUNT'), findsOneWidget);
  });

  testWidgets('opens the sign in screen from the welcome screen', (
    tester,
  ) async {
    await tester.pumpWidget(const KupkopApp());

    await tester.tap(find.text('I ALREADY HAVE AN ACCOUNT'));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);
  });

  testWidgets('opens the sign up screen from the welcome screen', (
    tester,
  ) async {
    await tester.pumpWidget(const KupkopApp());

    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Sign in With Google'), findsOneWidget);
    expect(find.text('Sign in With Facebook'), findsOneWidget);
  });

  testWidgets('opens sign in from the sign up screen', (tester) async {
    await tester.pumpWidget(const KupkopApp());

    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);
  });

  testWidgets('opens the forgot password screen from sign in', (tester) async {
    await tester.pumpWidget(const KupkopApp());

    await tester.tap(find.text('I ALREADY HAVE AN ACCOUNT'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Forgot Password'));
    await tester.pumpAndSettle();

    expect(find.text('Send Reset Link'), findsOneWidget);
    expect(find.text('Back to Sign In'), findsOneWidget);
  });
}
