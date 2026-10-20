import 'dart:convert';

class NoteModel {
  final String title;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory NoteModel.fromJson(String source) {
    try {
      return NoteModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
    } catch (_) {
      // Compatibilidad con notas simples guardadas en texto plano
      return NoteModel(title: 'Nota', content: source);
    }
  }
}
