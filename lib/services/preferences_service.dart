import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_keys.dart';
import '../models/note_model.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  String? getLoggedUser() {
    return _prefs.getString(AppKeys.loggedUser);
  }

  Future<bool> setLoggedUser(String username) async {
    return await _prefs.setString(AppKeys.loggedUser, username);
  }

  Future<bool> clearSession() async {
    return await _prefs.remove(AppKeys.loggedUser);
  }

  bool isLoggedIn() {
    final user = getLoggedUser();
    return user != null && user.trim().isNotEmpty;
  }

  List<String> getNotes() {
    return _prefs.getStringList(AppKeys.userNotes) ?? [];
  }

  Future<bool> saveNotes(List<String> notes) async {
    return await _prefs.setStringList(AppKeys.userNotes, notes);
  }

  List<NoteModel> getNotesList() {
    final rawNotes = getNotes();
    return rawNotes.map((item) => NoteModel.fromJson(item)).toList();
  }

  Future<bool> addNote(NoteModel note) async {
    final rawNotes = getNotes();
    rawNotes.add(note.toJson());
    return await saveNotes(rawNotes);
  }

  Future<bool> deleteNote(int index) async {
    final rawNotes = getNotes();
    if (index >= 0 && index < rawNotes.length) {
      rawNotes.removeAt(index);
      return await saveNotes(rawNotes);
    }
    return false;
  }
}
