import 'package:flutter/material.dart';
import 'Widgets/top_widgets.dart';

//
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cuprum',
      ),
      home: const MyHomePage(title: 'Hardiyanto'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //final String apiStartPoint = 'https://api.npoint.io/153137cab500f8c8f7bd';
  //final String apiStartPoint = 'https://web.hardiyanto.my.id/jsons/profile.json';
  @override
  Widget build(BuildContext context) {
    StackerTop topStacker = const StackerTop();

    return Scaffold(
      backgroundColor: Colors.white,
      body: topStacker,
    );
  }
}
