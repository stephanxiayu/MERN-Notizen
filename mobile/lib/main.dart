import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NoteList(),
    );
  }
}

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  List<dynamic> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    const url = 'http://localhost:8080/api/notes';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        notes = data;
      });
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  Future<void> deleteNote(String id) async {
    final url = Uri.parse('http://localhost:8080/api/notes/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Note deleted successfully');
    } else {
      throw Exception('Failed to delete note');
    }
  }
  // Future<void> deleteNoteFromServer(String id) async {
  //   final url = Uri.parse('http://localhost:8080/api/notes/$id');
  //   final existingNoteIndex = notes.indexWhere((note) => note.id == id);
  //   var existingNote = notes[existingNoteIndex];
  //   notes.removeAt(existingNoteIndex);

  //   try {
  //     final response = await http.delete(url);
  //     if (response.statusCode >= 400) {
  //       notes.insert(existingNoteIndex, existingNote);
  //       print('Could not delete note.');
  //       throw Exception('Could not delete note.');
  //     }
  //     existingNote = null;
  //   } catch (e) {
  //     print(e);
  //     notes.insert(existingNoteIndex, existingNote);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            print(notes);
            final note = notes[index];

            return Card(
              child: ListTile(
                title: Text(notes[index]['title']),
                subtitle: Text(notes[index]['text']),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete note'),
                          content: const Text(
                              'Are you sure you want to delete this note?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                setState(() {
                                  deleteNote(notes[index]['_id']);
                                  Navigator.of(context).pop();
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          },
        ));
  }
}
