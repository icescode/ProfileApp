// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api, // ignore: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:webapp/Classes/profile_data.dart';
import 'package:webapp/Shares/libshares.dart';

class StackerTop extends StatefulWidget {

  const StackerTop({super.key}) ;

  @override
  State<StackerTop> createState() => _StackerTop();

}

class _StackerTop extends State<StackerTop> {
  
  final double backgroundImageHeight = 200;
  final double profileImageHeight = 200;

  static const String defaultAssetProfile = 'assets/images/default_profile_image.jpg';
  static const String defaultAssetHeaderImage = 'assets/images/default_header_image.jpg';
  static const String loadingText = 'Loading Data Please Wait..';
  static const String placeholderText = '';

  static const dividerBig = SizedBox(height: 100.0);
  static const dividerSmall = SizedBox(height: 15.0);

  ProfileData myProfileData = ProfileData();
  List<Blocks> myBlocks = [];
  _StackerTop();

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
    ListTile profileDescription = styleListProfileDescription(myProfileData.about_heading ?? placeholderText, myProfileData.about ?? placeholderText);

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
    "img_background_url" : "https://iili.io/HKSCwMP.jpg",
    "img_profile_url" : "https://iili.io/HdzEeqP.jpg",    
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
      title: Text(title, style: TextStyle(fontSize: MyFontSize.fontMedium(), fontWeight: FontWeight.w100, color: MyCustomColor.blue())),
      subtitle: Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color:MyCustomColor.gray())),
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
            myProfileData.tagline ?? placeholderText,
            style: TextStyle(
              color: MyCustomColor.gray(),
              fontWeight: FontWeight.normal,
              fontSize: MyFontSize.fontNormal(),
            ),
          ),
        ],
      );

  Widget timeliner(String timeText, String title, String subtitle, String content, bool full) {

    if (!full) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(timeText, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black)),
        const SizedBox(width: 20),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.black)),
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: 
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: MyCustomColor.blue())),
                    Text(subtitle, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.white)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.4, color: MyCustomColor.gray()),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Text(content, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color: Colors.white60)),
                  ],
                ))
          ],
        ),
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
        if (tempBlock.fancy == null) {
          retvalItem.add(timeliner(timeText, title, subtitle, desc,false));
        }else {
          retvalItem.add(timeliner(timeText, title, subtitle, desc,true));
        }
        
        retvalItem.add(dividerSmall);
        
      }
      if(tempBlock.fancy == null) {
        retval.add(buildItemBlock(context, headerBlock, retvalItem, true));
      }else {
        retval.add(buildItemBlock(context, headerBlock, retvalItem, false));
      }
      
    }
    return retval;
  }

  Widget buildItemBlock(BuildContext context, String title, List<Widget> items,bool full) {
    Color tempColor = const Color.fromARGB(255, 255, 255, 255);
    double barSize = MediaQuery.of(context).size.width / 2;
    Color barColor = MyCustomColor.blue();
    Color barTextColor = const Color.fromARGB(255, 255, 255, 255);

    if (!full) {
      tempColor = const Color.fromARGB(255, 48, 47, 47);
      barSize = MediaQuery.of(context).size.width;
      barColor = Colors.white;
      barTextColor = MyCustomColor.blue();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15),
      //padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: barColor,
              width: barSize,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(title, style: TextStyle(fontSize: MyFontSize.fontNormal(), fontWeight: FontWeight.normal, color:barTextColor)),
              )),
          const SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: MyCustomColor.blue()),
              ),
              color: tempColor,
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
    //var client = HttpClient();
    try {

      /*
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      HttpClientRequest request = await client.getUrl(Uri.parse(urlApi));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();      
      final stringData = await response.transform(utf8.decoder).join();      
      var jsonData = await json.decode(stringData);
      */
      String localProfileJson = await rootBundle.loadString('assets/json/profile.json');
      final stringData = await jsonDecode(localProfileJson);

      setState(() {
        myProfileData = ProfileData.fromJson(stringData);
        myBlocks = myProfileData.blocks!;
      });
    } finally {
      //client.close();
    }
  }
}
