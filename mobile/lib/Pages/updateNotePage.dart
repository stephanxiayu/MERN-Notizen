import 'package:flutter/material.dart';
import 'package:mobile/Pages/NoteList.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UpdateNotePage extends StatefulWidget {
  final String title;
  final String text;
  final String id;
  const UpdateNotePage(
      {Key? key, required this.id, required this.title, required this.text})
      : super(key: key);

  @override
  State<UpdateNotePage> createState() => _UpdateNotePageState();
}

class _UpdateNotePageState extends State<UpdateNotePage> {
  List<dynamic> notes = [];
  Future<void> updateNote(String id, String title, String text) async {
    final url = 'http://localhost:8080/api/notes/$id';
    final response = await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'text': text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        // update the note in your state
        // assuming you have a 'notes' list that contains all your notes
        final noteIndex = notes.isNotEmpty
            ? notes.indexWhere((note) => note['_id'] == id)
            : -1;
        if (noteIndex >= 0) {
          notes[noteIndex] = data;
        }
      });
      Fluttertoast.showToast(
          msg: 'Note updated ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to update note',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    notes = [];
    titleController.text = widget.title;
    textController.text = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update your note"),
      ),
      body: Column(
        children: [
          TextFormField(
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 215, 195, 137),
            ),
            controller: titleController,
          ),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 215, 195, 137),
            ),
            style: const TextStyle(color: Colors.black),
            maxLines: 10,
            controller: textController,
            minLines: 6,
          ),
          TextButton.icon(
              onPressed: () {
                updateNote(widget.id, titleController.text, textController.text)
                    .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoteList(),
                        )));
              },
              icon: const Icon(Icons.save),
              label: const Text("Save"))
        ],
      ),
    );
  }
}
