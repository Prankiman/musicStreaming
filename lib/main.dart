import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

void writeData(data) async {
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference ref = FirebaseDatabase.instance.ref("users/123");

  await ref.update({
    "age": data,
  });
  print(data);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _textController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorSchemeSeed: Color.fromARGB(255, 224, 0, 0), useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('musicStreaming'),
          foregroundColor: Color.fromARGB(255, 213, 213, 213),
          backgroundColor: Color.fromARGB(255, 50, 50, 50),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter some text',
                ),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  writeData(textController.text);
                },
                child: Text('Write data'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
