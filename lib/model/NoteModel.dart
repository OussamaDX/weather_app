// lib/model/NoteModel.dart
class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  // Create a copy of the note with updated fields
  NoteModel copyWith({
    String? title,
    String? content,
  }) {
    return NoteModel(
      id: this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: this.createdAt,
    );
  }
}