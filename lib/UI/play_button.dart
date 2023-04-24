import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayButton extends StatefulWidget {


  final isHovering = ValueNotifier(false);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
     PlayButton({Key? key}) : super(key: key);



  void firebaseChangeState(bool data) async {

    DatabaseReference ref = FirebaseDatabase.instance.ref("/");

    await ref.update({"isPlaying": data});
  }

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  InkWell(
        onTap: () {
          final snackBar =  SnackBar(content: const Text("Playing Music"), backgroundColor: Colors.green.shade400, duration: const Duration(milliseconds: 600),);
          widget.isPlaying.value = !widget.isPlaying.value;
          widget.firebaseChangeState(widget.isPlaying.value);

          if(widget.isPlaying.value){
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            debugPrint("isPlaying");
          }

        },
        onHover: (isHovering) {
          widget.isHovering.value = isHovering;
          //debugPrint("hover");
        },
        child:  Positioned(
          bottom: 32,
          left: (screenWidth * 0.5) - (screenWidth * 0.2) / 2,
          child: ValueListenableBuilder(
            valueListenable: widget.isHovering,
            builder: (context, value, child) {
              return ValueListenableBuilder(
                valueListenable: widget.isPlaying,
                builder: (context, isPlayingValue, child) {
                  return Container(
                    width: screenWidth * 0.2,
                    height: screenWidth * 0.2,
                    decoration: BoxDecoration(
                      color: value ? Colors.grey : Colors.white,
                      borderRadius: BorderRadius.circular(screenWidth * 0.1),
                    ),


                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          isPlayingValue ? Icons.pause : Icons.play_arrow_rounded,
                          size: screenWidth * 0.1,
                          color: Colors.black,
                        ),
                      ),

                  );
                },
              );
            },
          ),
        )
    );
  }
}
