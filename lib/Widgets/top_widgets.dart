// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:webapp/Widgets/profiledataclass.dart';
import 'package:webapp/Widgets/contentpage.dart';
import 'package:webapp/Widgets/libshares.dart';

class StackerTop extends StatefulWidget {
  final String apiUrl;
  const StackerTop({Key? key, required this.apiUrl}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _StackerTop createState() => _StackerTop(apiUrl);
}

class _StackerTop extends State<StackerTop> {
  //final ProfileParams theParams;
  final String url_api;

  final double background_image_height = 200;
  final double profile_image_height = 150;

  static const double fontHuge = 64.0;
  static const double fontBig = 32.0;
  static const double fontMedium = 24.0;
  static const double fontStandar = 20.0;
  static const double miniDivider = 20.0;
  static const double bigDivider = 100.0;
  static const Color greenColor = Color.fromARGB(160, 148, 244, 194);
  static const Color greenDeepColor = Color.fromARGB(211, 13, 246, 125);

  ProfileData myProfileData = ProfileData();
  List<Stat> myStat = [];
  //List<Content> myContent = [];
  _StackerTop(this.url_api);

  @override
  void initState() {
    super.initState();
    loadDataProfile();
  }

  @override
  Widget build(BuildContext context) {
    final double pos_top = background_image_height - profile_image_height / 2;
    final double circleRadius = (profile_image_height / 2) + 2;

    //image background dan photo profile
    Widget topDecoration = _topDecoration(pos_top, circleRadius);

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
      _basicCard(),
      const SizedBox(height: miniDivider)
    ];

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
    var tmpProfileImage;
    if (myProfileData.imgProfileUrl == null) {
      tmpProfileImage = const ExactAssetImage('assets/images/profile-default.png');
    } else {
      tmpProfileImage = NetworkImage(myProfileData.imgProfileUrl.toString());
    }

    var tmpBackground;
    if (myProfileData.imgBackgroundUrl == null) {
      tmpBackground = const Image(image: AssetImage('assets/images/hb.jpg'));
    } else {
      tmpBackground = Image.network(
        myProfileData.imgBackgroundUrl.toString(),
        width: double.infinity,
        height: background_image_height,
        fit: BoxFit.cover,
      );
    }
    Widget backgroundImage(double coverHeight, String imageURL) => Container(
          color: greenColor,
          child: tmpBackground,
        );

    Widget profileImage(double profileHeight) => CircleAvatar(
          radius: profileHeight + 5,
          backgroundColor: Colors.white,
          child: (CircleAvatar(
            radius: profileHeight,
            backgroundColor: greenDeepColor,
            foregroundColor: Colors.blue,
            backgroundImage: tmpProfileImage,
          )),
        );
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        backgroundImage(background_image_height, myProfileData.imgBackgroundUrl.toString()),
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
      title: Text(title, style: const TextStyle(fontSize: fontMedium, fontWeight: FontWeight.bold, color: Colors.black)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: fontStandar, fontWeight: FontWeight.normal, color: Colors.black)),
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
        color: MyCustomColor.green(),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: greenColor, width: 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ListTile(
            tileColor: Colors.white,
            leading: const Icon(Icons.local_florist, size: fontBig, color: greenDeepColor),
            title: Text(aboutHeading ?? 'Loading..', style: const TextStyle(fontSize: fontMedium, fontWeight: FontWeight.normal, color: greenDeepColor)),
            subtitle: Text(pretext ?? 'Loading..', style: const TextStyle(fontSize: fontStandar, fontWeight: FontWeight.normal, color: Colors.black87)),
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
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: fontBig,
            ),
          ),
          Text(
            myProfileData.tagline ?? 'Loading',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontSize: fontStandar,
            ),
          ),
        ],
      );

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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: fontHuge,
                )),
            const SizedBox(height: 2),
            Text(text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                  fontSize: fontStandar,
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
      HttpClientRequest request = await client.getUrl(Uri.parse(url_api));
      request.headers.set('content-type', 'application/json');
      HttpClientResponse response = await request.close();
      final stringData = await response.transform(utf8.decoder).join();
      var jsonData = await json.decode(stringData);
      setState(() {
        myProfileData = ProfileData.fromJson(jsonData);
        myStat = myProfileData.stat!;
      });
    } finally {
      client.close();
    }
  }
}
