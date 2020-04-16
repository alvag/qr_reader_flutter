import 'package:flutter/material.dart';
import 'package:qr_reader_flutter/src/pages/home_page.dart';
import 'package:qr_reader_flutter/src/pages/map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QR Reader',
      initialRoute: 'home',
      routes: {
        'home': (context) => HomePage(),
        'map': (context) => MapPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    );
  }
}
