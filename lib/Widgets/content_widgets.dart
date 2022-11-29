import 'package:flutter/material.dart';
import 'package:webapp/Shares/libshares.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'dart:io';
import 'package:webapp/Classes/content_data.dart';

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
        foregroundColor: Colors.white,
        backgroundColor: MyCustomColor.gray(),
        title: Text(title_bar, style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.normal, color: Colors.white)),
      ),
      //body: Column(children: [card, _drawList()]),
      body: Column(
        children: [card, Expanded(child: _drawList())],
      ),
    );
  }

  // ignore: unused_element
  Widget _containerVisualData(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MyCustomColor.blue(),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: MyCustomColor.grayLight(), width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.local_florist, size: 28, color: MyCustomColor.blue()),
            title: Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.normal, color: MyCustomColor.grayLight())),
            subtitle: Text(subtitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black87)),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: MyCustomColor.blue(),
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
          leading: Icon(Icons.picture_as_pdf, size: 32, color: MyCustomColor.blue()),
          title: Text(dataSource[index].title.toString(), style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.bold, color: MyCustomColor.blue())),
          subtitle: Text(dataSource[index].simpledesc.toString(), style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: MyCustomColor.gray())),
          onTap: () {
            debugPrint('Index $index');
            _loadWebTools(dataSource[index].fileurl.toString());
          },
          shape: Border(
            bottom: BorderSide(
              color: MyCustomColor.blue(),
              width: .5,
            ),
          ),
        );
      },
    );
  }

  void _loadWebTools(String contentUrl) {
    debugPrint('URL PDF $contentUrl');
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => PDFViewer(
    //               url: contentUrl,
    //             )));
  }

  Widget _basicCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MyCustomColor.blue(),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: MyCustomColor.grayLight(), width: 1.0),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: SizedBox(
              height: double.infinity,
              child: Icon(Icons.local_florist, size: 48, color: MyCustomColor.gray()),
            ),
            title: Text(title, style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.normal, color: MyCustomColor.gray())),
            subtitle: Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black87)),
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
