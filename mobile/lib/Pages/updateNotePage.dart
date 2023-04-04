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
  Future<void> updateNotes() async {
    print("***** print test ");
    print(widget.id);
    final url = 'http://localhost:8080/api/notes/${widget.id}';
    final response = await http.patch(
      Uri.parse(url),
      body: {
        '_id': widget.id,
        'title': titleController.text,
        'text': textController.text,
        // 'updatedAt': datum,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        notes = data;
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to update notes',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
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
            controller: titleController,
          ),
          TextFormField(
            maxLines: 10,
            controller: textController,
            minLines: 6,
          ),
          TextButton.icon(
              onPressed: () {
                updateNotes().then((value) => Navigator.push(
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
