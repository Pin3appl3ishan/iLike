import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ilike/features/auth/presentation/pages/login_page.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/domain/usecases/login_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/register_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/logout_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:ilike/features/auth/domain/usecases/get_current_user_usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRegisterUseCase extends Mock implements RegisterUseCase {}

class MockLogoutUseCase extends Mock implements LogoutUseCase {}

class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}

void main() {
  group('LoginPage Widget Tests', () {
    late MockLoginUseCase mockLoginUseCase;
    late MockRegisterUseCase mockRegisterUseCase;
    late MockLogoutUseCase mockLogoutUseCase;
    late MockIsLoggedInUseCase mockIsLoggedInUseCase;
    late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
    late AuthBloc authBloc;

    setUp(() {
      mockLoginUseCase = MockLoginUseCase();
      mockRegisterUseCase = MockRegisterUseCase();
      mockLogoutUseCase = MockLogoutUseCase();
      mockIsLoggedInUseCase = MockIsLoggedInUseCase();
      mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();

      authBloc = AuthBloc(
        loginUseCase: mockLoginUseCase,
        registerUseCase: mockRegisterUseCase,
        logoutUseCase: mockLogoutUseCase,
        isLoggedInUseCase: mockIsLoggedInUseCase,
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginPage(),
        ),
      );
    }

    testWidgets('should display login form with email and password fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify that the login form is displayed
      expect(find.text('Login'), findsOneWidget);
      expect(find.byType(TextFormField),
          findsNWidgets(2)); // Email and password fields
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the login button and tap it without entering any data
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that validation error is shown
      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'invalid-email');

      // Find the login button and tap it
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that validation error is shown
      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('should show validation error for empty password field',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email but no password
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');

      // Find the login button and tap it
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that validation error is shown
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show validation error for short password',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email but short password
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '123');

      // Find the login button and tap it
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that validation error is shown
      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
    });

    testWidgets('should navigate to signup page when signup link is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find and tap the signup link
      final signupLink = find.text('Sign up');
      await tester.tap(signupLink);
      await tester.pumpAndSettle();

      // Verify navigation to signup page
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('should show loading indicator when login is in progress',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Find the login button and tap it
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Verify that loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show error message when login fails',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');

      // Find the login button and tap it
      final loginButton = find.text('Login');
      await tester.tap(loginButton);
      await tester.pump();

      // Simulate login failure
      authBloc.add(const LoginEvent(
        email: 'test@example.com',
        password: 'wrongpassword',
      ));
      await tester.pump();

      // Verify that error message is shown
      expect(find.text('Login failed'), findsOneWidget);
    });

    testWidgets('should toggle password visibility when eye icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password field
      final passwordField = find.byType(TextFormField).last;

      // Enter password
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Initially password should be obscured
      expect(tester.widget<TextFormField>(passwordField).obscureText, isTrue);

      // Find and tap the eye icon
      final eyeIcon = find.byIcon(Icons.visibility_off);
      await tester.tap(eyeIcon);
      await tester.pump();

      // Password should now be visible
      expect(tester.widget<TextFormField>(passwordField).obscureText, isFalse);
    });

    testWidgets('should have proper keyboard types for input fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Verify keyboard types
      expect(tester.widget<TextFormField>(emailField).keyboardType,
          TextInputType.emailAddress);
      expect(tester.widget<TextFormField>(passwordField).keyboardType,
          TextInputType.visiblePassword);
    });

    testWidgets('should have proper text input actions',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the email and password fields
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      // Verify text input actions
      expect(tester.widget<TextFormField>(emailField).textInputAction,
          TextInputAction.next);
      expect(tester.widget<TextFormField>(passwordField).textInputAction,
          TextInputAction.done);
    });
  });
}
