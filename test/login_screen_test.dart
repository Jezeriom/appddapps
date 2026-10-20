import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdda/core/constants/app_keys.dart';
import 'package:appdda/core/theme/app_theme.dart';
import 'package:appdda/screens/home_screen.dart';
import 'package:appdda/screens/login_screen.dart';
import 'package:appdda/services/preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
    );
  }

  testWidgets('LoginScreen renders all expected elements', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(find.text('Bienvenido de nuevo'), findsOneWidget);
    expect(find.byKey(const Key('login_user_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('El usuario no puede estar vacío'), findsOneWidget);
    expect(find.text('La contraseña no puede estar vacía'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors when inputs are too short', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_user_field')), 'ab');
    await tester.enterText(find.byKey(const Key('login_password_field')), '12345');
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('El usuario debe tener al menos 3 caracteres'), findsOneWidget);
    expect(find.text('La contraseña debe tener al menos 6 caracteres'), findsOneWidget);
  });

  testWidgets('LoginScreen toggles password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    final passwordFieldFinder = find.byKey(const Key('login_password_field'));
    TextField textField = tester.widget<TextField>(
      find.descendant(of: passwordFieldFinder, matching: find.byType(TextField)),
    );
    expect(textField.obscureText, isTrue);

    // Tap visibility icon
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pumpAndSettle();

    textField = tester.widget<TextField>(
      find.descendant(of: passwordFieldFinder, matching: find.byType(TextField)),
    );
    expect(textField.obscureText, isFalse);
  });

  testWidgets('LoginScreen successfully stores logged user in SharedPreferences and navigates to HomeScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('login_user_field')), 'antigravity_user');
    await tester.enterText(find.byKey(const Key('login_password_field')), 'password123');
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    // Verify navigation to HomeScreen
    expect(find.text('Panel de Notas'), findsOneWidget);
    expect(find.text('Crear nueva nota'), findsOneWidget);

    // Verify persistence in SharedPreferences
    final prefsService = await PreferencesService.getInstance();
    expect(prefsService.isLoggedIn(), isTrue);
    expect(prefsService.getLoggedUser(), 'antigravity_user');

    final rawPrefs = await SharedPreferences.getInstance();
    expect(rawPrefs.getString(AppKeys.loggedUser), 'antigravity_user');
  });
}
