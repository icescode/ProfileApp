import 'package:flutter/material.dart';
import 'package:webapp/Widgets/libshares.dart';
import 'package:webapp/Widgets/contentdataclass.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webapp/Widgets/webviewer.dart';

class ContentPage extends StatefulWidget {
  final String apiUrl;
  final String barTitle;
  final String description;
  final String title;

  const ContentPage({Key? key, required this.apiUrl, required this.barTitle, required this.description, required this.title}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _ContentPage createState() => _ContentPage(apiUrl, barTitle, description, title);
}

class _ContentPage extends State<ContentPage> {
  // ignore: non_constant_identifier_names
  final String url_api;
  // ignore: non_constant_identifier_names
  final String title_bar;
  final String description;
  final String title;

  List<Content> dataSource = [];

  _ContentPage(this.url_api, this.title_bar, this.description, this.title);

  @override
  void initState() {
    super.initState();
    loadDataContent();
  }

  @override
  Widget build(BuildContext context) {
    Widget card = _basicCard(title, description);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Text(title_bar),
      ),
      //body: Column(children: [card, _drawList()]),
      body: Column(
        children: [card, Expanded(child: _drawList())],
      ),
    );
  }

  // ignore: unused_element
  Widget _containerVisualData(String title, String subtitle) {
    Color greenColor = MyCustomColor.green();
    Color grayColor = MyCustomColor.gray();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: greenColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: greenColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.local_florist, size: 28, color: greenColor),
            title: Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal, color: grayColor)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black87)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: greenColor,
          )
        ]),
      ),
    );
  }

  Widget _drawList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: dataSource.length,
      itemBuilder: (context, index) {
        return ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: 4.0),
          leading: const Icon(Icons.picture_as_pdf, size: 32, color: Colors.redAccent),
          title: Text(dataSource[index].title.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54)),
          subtitle: Text(dataSource[index].simpledesc.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black45)),
          onTap: () {
            debugPrint('Index $index');
            _loadWebTools(dataSource[index].fileurl.toString());
          },
        );
      },
    );
  }

  void _loadWebTools(String contentUrl) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebTools(
                  url: contentUrl,
                  title: title_bar,
                )));
  }

  Widget _basicCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MyCustomColor.green(),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: MyCustomColor.green(), width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.local_florist, size: 32, color: MyCustomColor.green()),
            title: Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black87)),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }

  loadDataContent() async {
    var client = HttpClient();
    try {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.getUrl(Uri.parse(url_api));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      var jsonData = await json.decode(stringData);
      setState(() {
        var objectData = ContentDataClass.fromJson(jsonData);
        dataSource = objectData.content!;
      });
    } finally {
      client.close();
    }
  }
}
