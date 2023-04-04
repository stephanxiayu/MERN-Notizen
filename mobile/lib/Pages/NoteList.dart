import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/Pages/createNotePage.dart';
import 'package:mobile/Pages/updateNotePage.dart';
import 'package:intl/intl.dart';

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

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: 'Note gelöscht ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Fehler in der Matrix',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  TextEditingController? controller = TextEditingController();
  TextEditingController? controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('yyyy-MM-dd hh:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          print(notes);
          final note = notes[index];

          return GestureDetector(
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateNotePage(
                          id: notes[index]['_id'],
                          title: notes[index]['title'],
                          text: notes[index]['text'])));
              // updateNotes(
              //     notes[index]['_id'],
              //     notes[index]['title'],
              //     notes[index]['text'],
              //     notes[index]['updatedAt']);
              // Navigator.of(context).pop();
            },
            child: Card(
                color: const Color.fromARGB(255, 215, 195, 137),
                child: Column(
                  children: [
                    Text(
                      notes[index]['title'],
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      notes[index]['text'],
                      style: const TextStyle(color: Colors.black),
                    ),
                    Text(
                      DateFormat("dd.MM.yyyy HH:mm")
                          .format(DateTime.parse(notes[index]['createdAt'])),
                      style: const TextStyle(color: Colors.black),
                    ),
                    IconButton(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const NoteList()),
                                      );
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 215, 195, 137),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateNotePage()),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}
