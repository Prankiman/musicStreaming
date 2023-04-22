import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

List<String> stations = [];

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  getStations();
  runApp(const MaterialApp(
    title: "My Flutter App",
    home: MyDropdownButton(),
  ));

}
// Future<void> getSelectedStation() async{
//   final ref = FirebaseDatabase.instance.ref("currentStation");
//   final snapshot = await ref.get();
//   if (snapshot.exists) {
//     selectedStation =  snapshot.value.toString();
//     print(selectedStation);
//   } else {
//     print('No data available.');
//   }
// }
void changeStation(data) async {

  DatabaseReference ref = FirebaseDatabase.instance.ref("/");

  await ref.update({"currentStation": data});
  debugPrint(data);
}

void getStations() async{
  DatabaseReference stationsRef =
  FirebaseDatabase.instance.ref('stations');
  stationsRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.children;
    for (DataSnapshot s in data){
      stations.add(s.key.toString());
    }

    // for(var i=0; i<stations.length; i++){
    //   print(stations[i]);
    // }
  });
}


class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String? _selectedStation = "station1";
  final List<String> _stations = stations;
  final isHovering = ValueNotifier(false);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);


  @override
  Widget build(BuildContext context)  {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: const Text("Music streaming"),
      ),
      body: Material(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child:  SizedBox(
                width: screenWidth * 0.3,
                child: DropdownButton<String>(
                  value: _selectedStation,
                  dropdownColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  items: _stations.map((String station) {
                    return DropdownMenuItem<String>(
                      value: station,
                      child: Text(
                        station,
                        style: const  TextStyle(
                          color: Colors.amber,
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
            Positioned(
              bottom: 32,
              left: (screenWidth * 0.5) - (screenWidth * 0.1) / 2,
              child: ValueListenableBuilder(
                valueListenable: isHovering,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                    valueListenable: isPlaying,
                    builder: (context, isPlayingValue, child) {
                      return Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          color: value ? Colors.grey : Colors.white,
                          borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        ),
                        child: InkWell(
                          onHover: (isHovering) {
                            this.isHovering.value = isHovering;
                            //debugPrint("hover");
                          },
                          onTap: () {
                            //debugPrint("tapped");
                            isPlaying.value = !isPlaying.value;
                            debugPrint("$isPlaying");
                          },
                          child: IconButton(
                            onPressed: null,
                            icon: Icon(
                              isPlayingValue ? Icons.pause : Icons.play_arrow_rounded,
                              size: screenWidth * 0.05,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}