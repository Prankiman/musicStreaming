import 'package:flutter/material.dart';

class MyDropdownButton extends StatefulWidget {
  const MyDropdownButton({super.key});

  @override
  State<MyDropdownButton> createState() => MyDropdownButtonState();

}

class MyDropdownButtonState extends State<MyDropdownButton> {
  String? _selectedStation = "station1";
  final List<String> _stations = ["station1"];


  @override
  Widget build(BuildContext context)  {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return  Center(
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
  }
}