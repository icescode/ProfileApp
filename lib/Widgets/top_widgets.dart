// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, // ignore: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:webapp/Classes/profile_data.dart';
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

  static const String defaultAssetProfile = 'assets/images/profile-default.png';
  static const String defaultAssetHeaderImage = 'assets/images/blue_cover.jpg';
  static const String loadingText = 'Loading ..';
  static const dividerBig = SizedBox(height: 100.0);
  static const dividerSmall = SizedBox(height: 15.0);

  ProfileData myProfileData = ProfileData();
  List<Stat> myStat = [];
  List<Blocks> myBlocks = [];
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
    Widget topdecoration = topDecoration(posTop, circleRadius);

    //Heading text profile
    Widget myTextProfile = headingProfile();

    //deskripsi singkat profile
    ListTile profileDescription = styleListProfileDescription(myProfileData.about_heading ?? loadingText, myProfileData.about ?? loadingText);

    List<Widget> visualComponent = [
      topdecoration,
      dividerBig,
      myTextProfile,
      dividerSmall,
      profileDescription,
      dividerSmall,
    ];

    List<Widget> blocks = buildBlocks(context);
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

  Widget topDecoration(double ptop, double cradius) {
    /* 
    Karena circle avatar membutuhkan image ImageProvider,
    dan tidak boleh null, maka
    */
    Object tmpProfileImage;
    if (myProfileData.imgProfileUrl == null) {
      tmpProfileImage = const ExactAssetImage(defaultAssetProfile);
    } else {
      tmpProfileImage = NetworkImage(myProfileData.imgProfileUrl.toString());
    }

    Object tmpBackground;
    if (myProfileData.imgBackgroundUrl == null) {
      tmpBackground = const Image(image: AssetImage(defaultAssetHeaderImage));
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

  ListTile styleListProfileDescription(String title, String subtitle) {
    ListTile tile = ListTile(
      dense: true,
      visualDensity: const VisualDensity(vertical: 4.0),
      title: Text(title, style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black)),
    );

    return tile;
  }

  Widget headingProfile() => Column(
        children: [
          Text(
            myProfileData.name ?? loadingText,
            style: TextStyle(
              color: MyCustomColor.grayDeep(),
              fontWeight: FontWeight.normal,
              fontSize: MyFontSize.fontMedium(),
            ),
          ),
          Text(
            myProfileData.tagline ?? loadingText,
            style: TextStyle(
              color: MyCustomColor.gray(),
              fontWeight: FontWeight.normal,
              fontSize: MyFontSize.fontNormal(),
            ),
          ),
        ],
      );

  Widget timeliner(String timeText, String title, String subtitle, String content) {
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

  List<Widget> buildBlocks(BuildContext context) {
    int totalBlocks = myBlocks.length;
    List<Widget> retval = [];

    for (int i = 0; i < totalBlocks; i++) {
      // ignore: avoid_init_to_null
      Blocks tempBlock = myBlocks[i];
      List tempBlockItem = tempBlock.blockItem as List;
      String headerBlock = tempBlock.title.toString();

      List<Widget> retvalItem = [];
      for (int j = 0; j < tempBlockItem.length; j++) {
        BlockItem item = tempBlockItem[j];
        String timeText = item.timeText.toString();
        String desc = item.desc.toString();
        String title = item.title.toString();
        String subtitle = item.subtitle.toString();

        retvalItem.add(timeliner(timeText, title, subtitle, desc));
        retvalItem.add(dividerSmall);
        
      }
      retval.add(buildItemBlock(context, headerBlock, retvalItem));
    }
    return retval;
  }

  Widget buildItemBlock(BuildContext context, String title, List<Widget> items) {
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

  void loadDataProfile() async {
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
