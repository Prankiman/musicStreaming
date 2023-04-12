import 'package:flutter/material.dart';

void main() {
  debugPrint("starting app");
  runApp(MaterialApp(
    title: "My Flutter App",
    home: MyDropdownButton(),
  ));
}

class MyDropdownButton extends StatefulWidget {
  @override
  _MyDropdownButtonState createState() => _MyDropdownButtonState();
}

class _MyDropdownButtonState extends State<MyDropdownButton> {
  String? _selectedStation = "station1";
  final List<String> _stations = ["station1", "station2", "station3"];
  final isHovering = ValueNotifier(false);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);


  @override
  Widget build(BuildContext context) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black38,
        title: Text("Music streaming"),
      ),
      body: Material(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Container(
                width: screenWidth * 0.7,
                child: DropdownButton<String>(
                  value: _selectedStation,
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  items: _stations.map((String station) {
                    return DropdownMenuItem<String>(
                      value: station,
                      child: Text(
                        station,
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedStation = newValue;
                    });
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
                            debugPrint("hover");
                          },
                          onTap: () {
                            debugPrint("tapped");
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