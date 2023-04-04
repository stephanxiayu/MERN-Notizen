import 'package:flutter/material.dart';
import 'package:mobile/Pages/NoteList.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CreateNotePage extends StatefulWidget {
  String? title;
  String? text;

  CreateNotePage({super.key, this.title, this.text});
  // const CreateNotePage(
  //     {super.key,
  //     //  required this.id, required this.title, required this.text
  //      });

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  List<dynamic> notes = [];

  Future<void> createNote(String title, String text) async {
    const url = 'http://localhost:8080/api/notes';
    final response = await http.post(
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
        notes.add(data);
      });
      Fluttertoast.showToast(
          msg: 'Note created ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to create note',
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
    // titleController.text = widget.title.toString();
    // textController.text = widget.text.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your note"),
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
                createNote(titleController.text, textController.text)
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
