import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes {
    return [..._notes];
  }

  Future<void> fetchNotesFromServer() async {
    final url = Uri.parse('http://localhost:8080/api/notes');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData != null) {
        final List<dynamic> data = responseData;
        final List<Note> loadedNotes = [];
        for (var noteData in data) {
          final note = Note(
            id: noteData['_id'],
            title: noteData['title'],
            text: noteData['text'],
            createdAt: DateTime.parse(responseData['createdAt']),
            updatedAt: DateTime.parse(responseData['updatedAt']),
          );
          loadedNotes.add(note);
        }
        _notes = loadedNotes;
      }
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> addNoteToServer(Note note) async {
    final url = Uri.parse('http://localhost:8080/api/notes');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': note.title,
          'text': note.text,
        }),
      );
      final responseData = json.decode(response.body);
      final newNote = Note(
        id: responseData['_id'],
        title: responseData['title'],
        text: responseData['text'],
        createdAt: DateTime.parse(responseData['createdAt']),
        updatedAt: DateTime.parse(responseData['updatedAt']),
      );
      _notes.add(newNote);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateNoteInServer(Note note) async {
    final url = Uri.parse('http://localhost:8080/api/notes/${note.id}');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': note.title,
          'text': note.text,
        }),
      );
      final responseData = json.decode(response.body);
      final updatedNoteIndex =
          _notes.indexWhere((note) => note.id == responseData['_id']);
      final updatedNote = Note(
        id: responseData['_id'],
        title: responseData['title'],
        text: responseData['text'],
        createdAt: DateTime.parse(responseData['createdAt']),
        updatedAt: DateTime.parse(responseData['updatedAt']),
      );
      _notes[updatedNoteIndex] = updatedNote;
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> deleteNoteFromServer(String id) async {
    final url = Uri.parse('http://localhost:8080/api/notes/$id');
    final existingNoteIndex = _notes.indexWhere((note) => note.id == id);
    Note? existingNote = _notes[existingNoteIndex];
    _notes.removeAt(existingNoteIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _notes.insert(existingNoteIndex, existingNote);
      notifyListeners();
      throw Exception('Could not delete note.');
    }
    existingNote = null;
  }
}

class Note {
  final String id;
  final String title;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['_id'] as String,
      title: map['title'] as String,
      text: map['text'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'text': text,
    };
  }
}
