import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/Pages/NoteList.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Dio dio = Dio();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final sessionCookie = prefs.getString('sessionCookie');

    if (userId == null) {
      // Handle case when userId is not available
      print("userId: $userId");
      return;
    }

    print("userId: $userId");

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Cookie'] = sessionCookie;
          return handler.next(options);
        },
      ),
    );

    const url = 'https://meine-notizen.com/api/notes';
    final response = await dio.post(
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
        notes.add(data);
      });
      Fluttertoast.showToast(
          msg: 'Note created ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.yellow,
          textColor: Colors.black,
          fontSize: 20.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Failed to create note',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.black,
          fontSize: 20.0);
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
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Notiz hinzufügen",
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
                  //add more color here.
                ],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
          ),
        ),
      ),
      body: Column(
        children: [
          TextFormField(
            cursorColor: Colors.black87, // Set the cursor color here.
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              focusColor: Colors.black,
              labelStyle: const TextStyle(color: Colors.grey),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
              labelText: 'Titel...',
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
            cursorColor: Colors.black87, // Set the cursor color here.
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2.0)),
              labelText: 'Text der Notiz...',
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
              backgroundColor: Colors.black, //change the background color here
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              createNote(titleController.text, textController.text)
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
              'Notiz hinzufügen',
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
                      //add more color here.
                    ],
                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
