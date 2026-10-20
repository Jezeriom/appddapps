import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appdda/core/constants/app_keys.dart';
import 'package:appdda/main.dart';
import 'package:appdda/models/note_model.dart';
import 'package:appdda/services/preferences_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp(isLoggedIn: false));
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });

  testWidgets('App displays HomeScreen when logged in', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      AppKeys.loggedUser: 'UsuarioPrueba',
    });

    await tester.pumpWidget(const MyApp(isLoggedIn: true));
    await tester.pumpAndSettle();

    expect(find.text('Panel de Notas'), findsOneWidget);
    expect(find.text('Crear nueva nota'), findsOneWidget);
  });

  test('NoteModel serialization and deserialization', () {
    final note = NoteModel(title: 'Título Test', content: 'Contenido Test');
    final jsonStr = note.toJson();
    final parsedNote = NoteModel.fromJson(jsonStr);

    expect(parsedNote.title, 'Título Test');
    expect(parsedNote.content, 'Contenido Test');
  });

  test('PreferencesService session and note operations', () async {
    SharedPreferences.setMockInitialValues({});
    final service = await PreferencesService.getInstance();

    expect(service.isLoggedIn(), isFalse);

    await service.setLoggedUser('dev_user');
    expect(service.isLoggedIn(), isTrue);
    expect(service.getLoggedUser(), 'dev_user');

    final note = NoteModel(title: 'Nota 1', content: 'Texto 1');
    await service.addNote(note);
    expect(service.getNotesList().length, 1);
    expect(service.getNotesList().first.title, 'Nota 1');

    await service.deleteNote(0);
    expect(service.getNotesList().isEmpty, isTrue);

    await service.clearSession();
    expect(service.isLoggedIn(), isFalse);
  });
}
