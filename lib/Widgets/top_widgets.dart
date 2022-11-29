// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, // ignore: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:webapp/Classes/profile_data.dart';
import 'package:webapp/Widgets/content_widgets.dart';
import 'package:webapp/Shares/libshares.dart';

class StackerTop extends StatefulWidget {
  final String apiUrl;
  const StackerTop({Key? key, required this.apiUrl}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state, library_private_types_in_public_api
  _StackerTop createState() => _StackerTop(apiUrl);
}

class _StackerTop extends State<StackerTop> {
  //final ProfileParams theParams;
  final String urlApi;

  final double backgroundImageHeight = 200;
  final double profileImageHeight = 150;

  static const double miniDivider = 15.0;
  static const double bigDivider = 100.0;

  ProfileData myProfileData = ProfileData();
  List<Stat> myStat = [];
  List<Blocks> myBlocks = [];
  //List<Content> myContent = [];
  _StackerTop(this.urlApi);

  @override
  void initState() {
    super.initState();
    loadDataProfile();
  }

  @override
  Widget build(BuildContext context) {
    final double posTop = backgroundImageHeight - profileImageHeight / 2;
    final double circleRadius = (profileImageHeight / 2) + 2;

    //image background dan photo profile
    Widget topDecoration = _topDecoration(posTop, circleRadius);

    //Heading text profile
    Widget myTextProfile = _headingProfile();

    //deskripsi singkat profile
    ListTile profileDescription = _styleListProfileDescription(myProfileData.about_heading ?? 'Loading..', myProfileData.about ?? 'Loading..', 'S');

    List<Widget> visualComponent = [
      topDecoration,
      const SizedBox(height: bigDivider),
      myTextProfile,
      const SizedBox(height: miniDivider),
      profileDescription,
      const SizedBox(height: miniDivider),
    ];

    List<Widget> blocks = _buildBlocks(context);
    int totalBlocks = blocks.length;
    for (int i = 0; i < totalBlocks; i++) {
      visualComponent.add(blocks[i]);
    }
    return ListView(
      padding: EdgeInsets.zero,
      children: visualComponent,
    );
  }

  //Method widget komponen

  Widget _topDecoration(double ptop, double cradius) {
    /* 
    Karena circle avatar membutuhkan image ImageProvider,
    dan tidak boleh null, maka
    */
    Object tmpProfileImage;
    if (myProfileData.imgProfileUrl == null) {
      tmpProfileImage = const ExactAssetImage('assets/images/profile-default.png');
    } else {
      tmpProfileImage = NetworkImage(myProfileData.imgProfileUrl.toString());
    }

    Object tmpBackground;
    if (myProfileData.imgBackgroundUrl == null) {
      tmpBackground = const Image(image: AssetImage('assets/images/blue_cover.jpg'));
    } else {
      tmpBackground = Image.network(
        myProfileData.imgBackgroundUrl.toString(),
        width: double.infinity,
        height: backgroundImageHeight,
        fit: BoxFit.cover,
      );
    }
    Widget backgroundImage(double coverHeight, String imageURL) => Container(
          color: MyCustomColor.blue(),
          child: tmpBackground as Widget,
        );

    Widget profileImage(double profileHeight) => CircleAvatar(
          radius: profileHeight + 5,
          backgroundColor: Colors.white,
          child: (CircleAvatar(
            radius: profileHeight,
            backgroundColor: MyCustomColor.blue(),
            foregroundColor: Colors.blue,
            backgroundImage: tmpProfileImage as ImageProvider,
          )),
        );
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        backgroundImage(backgroundImageHeight, myProfileData.imgBackgroundUrl.toString()),
        Positioned(
          top: ptop,
          child: profileImage(cradius),
        ),
      ],
    );
  }

  ListTile _styleListProfileDescription(String title, String subtitle, String prefix) {
    ListTile tile = ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: 4.0),
      title: Text(title, style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black)),
    );

    return tile;
  }

  Widget _basicCard() {
    var aboutHeading = myProfileData.content_heading;
    var pretext = myProfileData.content_pretext;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MyCustomColor.blue(),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: MyCustomColor.grayLight(), width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: Icon(Icons.local_florist, size: MyFontSize.fontBig(), color: MyCustomColor.blue()),
            title: Text(aboutHeading ?? 'Loading..', style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.normal, color: MyCustomColor.gray())),
            subtitle: Text(pretext ?? 'Loading..', style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black87)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStat(),
          ),
        ]),
      ),
    );
  }

  Widget _headingProfile() => Column(
        children: [
          Text(
            myProfileData.name ?? 'Loading',
            style: TextStyle(
              color: MyCustomColor.grayDeep(),
              fontWeight: FontWeight.normal,
              fontSize: MyFontSize.fontMedium(),
            ),
          ),
          Text(
            myProfileData.tagline ?? 'Loading',
            style: TextStyle(
              color: MyCustomColor.gray(),
              fontWeight: FontWeight.normal,
              fontSize: MyFontSize.fontNormal(),
            ),
          ),
        ],
      );

  Widget _timeliner(String timeText, String title, String subtitle, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(timeText, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(width: 20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.bold, color: Colors.black)),
            Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: MyCustomColor.grayDeep())),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 0.5, color: MyCustomColor.gray()),
                ),
                color: Colors.white,
              ),
            ),
            Text(content, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: MyCustomColor.gray())),
          ],
        ))
      ],
    );
  }

  List<Widget> _buildBlocks(BuildContext context) {
    int totalBlocks = myBlocks.length;
    List<Widget> retval = [];

    for (int i = 0; i < totalBlocks; i++) {
      // ignore: avoid_init_to_null
      Blocks tempBlock = myBlocks[i];
      List tempBlockItem = tempBlock.blockItem as List;
      String headerBlock = tempBlock.title.toString();

      debugPrint('Kalang  pertama $headerBlock');
      List<Widget> retvalItem = [];
      for (int j = 0; j < tempBlockItem.length; j++) {
        BlockItem item = tempBlockItem[j];
        String timeText = item.timeText.toString();
        String desc = item.desc.toString();
        String title = item.title.toString();
        String subtitle = item.subtitle.toString();

        retvalItem.add(_timeliner(timeText, title, subtitle, desc));
        retvalItem.add(const SizedBox(height: 15));
        debugPrint('timenya $timeText');
        debugPrint('tdesc nya $desc');
      }
      retval.add(_buildItemBlock(context, headerBlock, retvalItem));
    }
    return retval;
  }

  Widget _buildItemBlock(BuildContext context, String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
      //padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: MyCustomColor.blue(),
              width: MediaQuery.of(context).size.width / 2,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(title, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.white)),
              )),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: MyCustomColor.blue()),
              ),
              color: Colors.white,
            ),
            //color: Colors.white,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: items,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildStat() {
    void prosesIndex(int index, String api, String title, String desc) {
      if ((api.isEmpty) || (api == '#')) {
        return;
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ContentPage(
                    apiUrl: api,
                    barTitle: myProfileData.navigator_title_back.toString(),
                    description: desc,
                    title: title,
                  )));

      // switch (index) {
      //   case 1:
      //     debugPrint('Index $index API $api');
      //     break;
      //   default:
      // }
    }

    Widget statContainer(String value, String text, int index, String api, String desc) => MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 4),
          onPressed: () {
            prosesIndex(index, api, text, desc);
          },
          child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            Text(value,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: MyFontSize.fontHuge(),
                )),
            const SizedBox(height: 2),
            Text(text,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  fontSize: MyFontSize.fontStandar(),
                )),
          ]),
        );

    List<Widget> retval = [];
    int totalData = myStat.length;
    for (int i = 0; i < totalData; i++) {
      var item = myStat[i];
      Widget children = statContainer(item.value.toString(), item.title.toString(), item.index!, item.api.toString(), item.desc.toString());
      retval.add(children);
    }
    return retval;
  }

  loadDataProfile() async {
    var client = HttpClient();
    try {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.getUrl(Uri.parse(urlApi));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      var jsonData = await json.decode(stringData);
      setState(() {
        myProfileData = ProfileData.fromJson(jsonData);
        myStat = myProfileData.stat!;
        myBlocks = myProfileData.blocks!;
      });
    } finally {
      client.close();
    }
  }
}
