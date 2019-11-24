import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';

class breathePage extends StatelessWidget{




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Just a moment !'),
      ),

      body: Container(
        child: FlareActor(
          "assets/breathe.flr",
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "Breathing",
        ),
      ),

    );
  }



}