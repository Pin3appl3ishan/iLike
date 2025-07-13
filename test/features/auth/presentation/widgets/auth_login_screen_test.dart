import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:ilike/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ilike/features/auth/presentation/pages/login_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  testWidgets('should display Login button and fields', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    whenListen(mockAuthBloc, Stream.value(AuthInitial()));
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('should show error SnackBar on AuthError', (
    WidgetTester tester,
  ) async {
    whenListen(
      mockAuthBloc,
      Stream<AuthState>.fromIterable([
        AuthInitial(),
        AuthError(message: 'Invalid credentials'),
      ]),
      initialState: AuthInitial(),
    );
    when(
      () => mockAuthBloc.state,
    ).thenReturn(AuthError(message: 'Invalid credentials'));
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();
    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  testWidgets('should call LoginEvent when login button pressed', (
    WidgetTester tester,
  ) async {
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
    whenListen(mockAuthBloc, Stream.value(AuthInitial()));
    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'test@email.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pump();
    verify(() => mockAuthBloc.add(any(that: isA<LoginEvent>()))).called(1);
  });
}
