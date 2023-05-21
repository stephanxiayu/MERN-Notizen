import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/Pages/LoginPage.dart';
import 'package:mobile/Pages/createNotePage.dart';
import 'package:intl/intl.dart';
import 'package:mobile/Pages/updateNotePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _logout() async {
    const url =
        'http://localhost:8080/api/user/logout'; // replace with your server URL
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Removes the user token from storage

      await prefs.setBool('isLoggedIn', false);

      // After removing the token, you could navigate the user to the login page
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginForm()));
      print('Logged out successfully');
    } else {
      // If the server did not return a 200 OK response,
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to logout');
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
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Meine Notizen",
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
        actions: [
          IconButton(
              onPressed: () {
                _logout();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.yellow,
              ))
        ],
      ),
      body: GridView.builder(
        itemCount: notes.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
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
              child: GridTile(
                header: Text(
                  notes[index]['title'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                footer: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("dd.MM.yyyy HH:mm")
                            .format(DateTime.parse(notes[index]['createdAt'])),
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 12),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.black87,
                                title: const Text(
                                  'Notiz löschen?',
                                  style: TextStyle(color: Colors.yellowAccent),
                                ),
                                content: const Text(
                                    'Bist du sicher, dass du die Notiz löschen möchtest'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      'abbrechen',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  TextButton(
                                    child: const Text(
                                      'löschen',
                                      style: TextStyle(color: Colors.yellow),
                                    ),
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
                        icon: Icon(
                          Icons.delete,
                          color: Colors.grey.shade900,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      notes[index]['text'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNotePage()),
          );
        },
        // Handle your butt(
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[
                Colors.orangeAccent,
                Colors.yellowAccent,
                Colors.yellow,
                Colors.yellowAccent,
                Colors.orangeAccent
                //add more colors here.
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            constraints: const BoxConstraints.expand(),
            child: const Icon(Icons.add), // you can add your icon here
          ),
        ),
      ),
    );
  }
}
