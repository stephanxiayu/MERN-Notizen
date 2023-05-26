import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Pages/NoteList.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final sessionCookie = prefs.getString('sessionCookie');

    if (userId == null) {
      // Handle case when userId is not available
      print("userId: $userId");
      return;
    }

    Dio dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Cookie'] = sessionCookie;
          return handler.next(options);
        },
      ),
    );

    final url = 'http://localhost:8080/api/notes/$id';
    final response = await dio.patch(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
      data: jsonEncode({
        'userId': userId,
        'title': title,
        'text': text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(response.data);
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
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 20.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to update note',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.black,
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
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Notiz ändern",
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[
                  Colors.orangeAccent,
                  Colors.yellowAccent,
                  Colors.yellow,
                  Colors.yellowAccent,
                  Colors.orangeAccent
                ],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextFormField(
              cursorColor: Colors.black87,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
                labelText: 'Title...',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 215, 195, 137),
              ),
              controller: titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              cursorColor: Colors.black87,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
                labelText: 'Note text...',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 215, 195, 137),
              ),
              maxLines: 10,
              controller: textController,
              minLines: 6,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.yellow),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                updateNote(widget.id, titleController.text, textController.text)
                    .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NoteList(),
                        )));
              },
              icon: const Icon(
                Icons.save,
                color: Colors.yellow,
              ),
              label: Text(
                'Änderung speichern',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Colors.orangeAccent,
                        Colors.yellowAccent,
                        Colors.yellow,
                        Colors.yellowAccent,
                        Colors.orangeAccent
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
