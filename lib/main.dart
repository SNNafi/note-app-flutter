import 'package:flutter/material.dart';
import 'package:note_app/NoteList.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:note_app/utils/theme_changer.dart';






void main() {
  runApp(ThemeBuilder(
      defaultBrightness: Brightness.dark,
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'NoteKeeper',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Tomorrow',
              primarySwatch: Colors.indigo,
              brightness: _brightness),
          home: splashScreen(),
        );
      })
  );
  }





class splashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _splashScreenState();
  }
}

class _splashScreenState extends State<splashScreen> {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/splash.png');
    Image image = Image(image: assetImage);

    // TODO: implement build
    return SplashScreen(
      seconds: 3,//3
      image: image,
      navigateAfterSeconds: NoteList(),
      backgroundColor: Color.fromRGBO(213, 245, 227, 1),
      title: Text(
        'Note App',
        style: TextStyle(

          fontSize: 40.0,
          color:Color.fromRGBO(52, 73, 94, 1) ,


        ),
      ),




      photoSize: 128.0,
      loaderColor: Color.fromRGBO(244, 208, 63, 1),


    );
  }
}
