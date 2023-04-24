import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import './UI/play_button.dart';




List<String> stations = [];

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //getStations();
  runApp(const MaterialApp(
    title: "My Flutter App",
    debugShowCheckedModeBanner: false,
    home: App(),
  ));

}


class App extends StatefulWidget {
   const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  int themeColorIndex = 0;
  Color appBarColor = Colors.primaries[0].shade900;
  Color bgColor = Colors.primaries[0].shade700;
  Color btnColor = Colors.primaries[0].shade800;

  String? _selectedStation = "NRJ";
  List<String> _stations = [];

  void getStations() async{
    DatabaseReference stationsRef =
    FirebaseDatabase.instance.ref('stations');
    stationsRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      List<String> st = [];
      for (DataSnapshot s in data){
        st.add(s.key.toString());
      }

      setState(() {
        _stations = st;
      });


    });
  }

  void changeStation(data) async {

    DatabaseReference ref = FirebaseDatabase.instance.ref("/");

    await ref.update({"currentStation": data});
    debugPrint(data);
  }

  @override
  Widget build(BuildContext context) {
    if(_stations.isEmpty){
      getStations();
    }
    debugPrint("build");
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar:  AppBar(
        title: const Text("MusicStreaming"),
        centerTitle: true,
        backgroundColor:appBarColor ,
        actions:  <Widget>[
          IconButton(onPressed: (){

            setState(() {
              themeColorIndex++;
              if(themeColorIndex >= Colors.primaries.length){themeColorIndex = 0;}

              appBarColor = Colors.primaries[themeColorIndex].shade900;
              bgColor = Colors.primaries[themeColorIndex].shade700;
              Color btnColor = Colors.primaries[themeColorIndex].shade800;
            });

          }, icon: const Icon(Icons.change_circle)),

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  SecondRoute(appBarColor: appBarColor, bgColor: bgColor,)),

          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),

      backgroundColor: bgColor,
      body: Container(
          alignment: Alignment.center,

        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child:  SizedBox(
                width: screenWidth * 0.3,
                child: DropdownButton<String>(
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(8),
                  value: _selectedStation,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  items: _stations.map((String station) {
                    return DropdownMenuItem<String>(
                      value: station,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          station,
                          style: const  TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStation = newValue;
                    });
                    changeStation(newValue);
                  },
                ),
              ),
            ),
             Center(
              child:  PlayButton()
            ),

          ],
        ),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {

  SecondRoute({Key? key, required this.appBarColor, required this.bgColor}) : super(key: key);

  final Color appBarColor;
  final Color bgColor;

  void addStation(name, url) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("/stations");

    await ref.update({name: url});
  }
  @override
  State<SecondRoute> createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {

  final _nameController = TextEditingController();
  final _urlController = TextEditingController();/// create a TextEditingController instance
  String _url = '';
  String _stationName = ''; // initialize a variable to hold the text value

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();// dispose the TextEditingController instance
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Add Station'),
        centerTitle: true,
        backgroundColor: widget.appBarColor,
      ),
      body: Container(
        color: widget.bgColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller: _nameController, // set the TextEditingController instance
                    onChanged: (value) {
                      setState(() {
                        _stationName = value;
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration:  InputDecoration(
                      fillColor: widget.appBarColor,
                      filled: true,
                      border: UnderlineInputBorder(),
                      labelText: 'Enter station name',
                        labelStyle: TextStyle(color:Colors.white),
                        focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // set the focused underline color
                  ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: screenWidth/2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    controller: _urlController, // set the TextEditingController instance
                    onChanged: (value) {
                      setState(() {
                        _url = value;
                        debugPrint(_url);
                      });
                    },
                    style: TextStyle(color: Colors.white),
                    decoration:  InputDecoration(
                      fillColor: widget.appBarColor,
                      filled: true,
                      border: const UnderlineInputBorder(),
                      labelText: 'Enter URL',
                      labelStyle: TextStyle(color:Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white), // set the focused underline color
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if(_url =='' || _stationName == '' ){
                    final snackBar =  SnackBar(content: const Text("invalid input!"), backgroundColor: Colors.red.shade400, duration: const Duration(milliseconds: 600),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    widget.addStation(_stationName, _url);
                    Navigator.pop(context);
                    final snackBar =  SnackBar(content:  Text("added $_stationName"), backgroundColor: Colors.green.shade400, duration: const Duration(milliseconds: 1000),);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    _stationName = '';
                    _url = '';
                  }


                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

