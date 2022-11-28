import 'package:flutter/material.dart';

class WebTools extends StatefulWidget {
  final String url;
  final String title;

  const WebTools({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _WebTools createState() => _WebTools(url, title);
}

class _WebTools extends State<WebTools> {
  // ignore: non_constant_identifier_names
  final String the_url;
  // ignore: non_constant_identifier_names
  final String the_title;

  _WebTools(this.the_url, this.the_title);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(the_title),
      ),
      //body: Column(children: [card, _drawList()]),
    );
  }
}
