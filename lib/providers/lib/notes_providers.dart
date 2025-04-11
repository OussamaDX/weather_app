// lib/providers/notes_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_app/model/NoteModel.dart';
import '';

// State notifier to manage notes
class NotesNotifier extends StateNotifier<List<NoteModel>> {
  NotesNotifier() : super([]);
  
  void addNote(String title, String content) {
    final newNote = NoteModel(
      id: const Uuid().v4(),
      title: title,
      content: content,
    );
    state = [...state, newNote];
  }
  
  void updateNote(String id, String title, String content) {
    state = state.map((note) => 
      note.id == id 
        ? note.copyWith(title: title, content: content)
        : note
    ).toList();
  }
  
  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

// Provider for notes state
final notesProvider = StateNotifierProvider<NotesNotifier, List<NoteModel>>((ref) {
  return NotesNotifier();
});