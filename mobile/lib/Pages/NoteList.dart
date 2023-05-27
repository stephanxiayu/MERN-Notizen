import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  Dio dio = Dio();
  @override
  void initState() {
    super.initState();
    fetchNotes();
    dio.interceptors.add(CookieManager(CookieJar()));
  }

  Future<void> fetchNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // Handle case when userId is not available
      print("userId: $userId");
      return;
    }

    print("userId: $userId");

    final url = 'https://meine-notizen.com/api/notes?userId=$userId';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final sessionCookie = prefs.getString('sessionCookie');
          options.headers['Cookie'] = sessionCookie;
          return handler.next(options);
        },
      ),
    );

    final response = await dio.get(url);

    if (response.statusCode == 200) {
      print("userId: $userId");
      final List<dynamic> data = List<dynamic>.from(response.data);
      setState(() {
        notes = data;
      });
    } else {
      throw Exception('Failed to fetch notes');
      print("userId: $userId");
    }
    print("userId: $userId");
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // Handle case when userId is not available
      print("userId: $userId");
      return;
    }

    print("userId: $userId");

    final url = 'https://meine-notizen.com/api/user/logout?userId=$userId';

    final response = await dio.post(url);

    if (response.statusCode == 200) {
      await prefs.setBool('isLoggedIn', false);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const LoginForm()));
      print('Logged out successfully');
    } else {
      throw Exception('Failed to logout');
    }
  }

  Future<void> deleteNote(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) {
      // Handle case when userId is not available
      print("userId: $userId");
      return;
    }

    print("userId: $userId");

    final url = 'https://meine-notizen.com/api/notes/$id?userId=$userId';

    final response = await dio.delete(url);

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
          msg: 'Note gelöscht ',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.amber,
          textColor: Colors.black,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: 'Fehler in der Matrix',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.black,
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
      body: Stack(children: [
        // This is your background picture.
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/office2.jpg"), // Change this to your image path.
              fit: BoxFit.cover,
            ),
          ),
        ),
        GridView.builder(
          itemCount: notes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
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
              },
              child: Card(
                elevation: 9,
                color: const Color.fromARGB(255, 215, 195, 137),
                child: GridTile(
                  header: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      notes[index]['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat("dd.MM.yyyy HH:mm").format(
                              DateTime.parse(notes[index]['createdAt'])),
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
                                    style:
                                        TextStyle(color: Colors.yellowAccent),
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
                                        deleteNote(notes[index]['_id'])
                                            .then((value) {
                                          setState(() {
                                            notes.removeAt(index);
                                          });
                                          Navigator.of(context).pop();
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
                            color: Colors.grey.shade700,
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
      ]),
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
            child: const Icon(Icons.create), // you can add your icon here
          ),
        ),
      ),
    );
  }
}
