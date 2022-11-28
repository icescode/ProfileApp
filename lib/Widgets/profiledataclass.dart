// ignore_for_file: non_constant_identifier_names
class Stat {
  String? title;
  String? api;
  int? value;
  int? index;
  String? desc;
  Stat({this.title, this.value, this.api, this.index, this.desc});

  Stat.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
    index = json['index'];
    api = json['apiurl'];
    desc = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    data['index'] = index;
    data['apiurl'] = api;
    data['description'] = desc;
    return data;
  }
}

class ProfileData {
  String? name;
  List<Stat>? stat;
  String? about;
  String? tagline;
  String? imgProfileUrl;
  String? imgBackgroundUrl;
  String? about_heading;
  String? content_heading;
  String? content_pretext;
  String? navigator_title_back;

  ProfileData({this.name, this.stat, this.about, this.tagline, this.imgProfileUrl, this.imgBackgroundUrl, this.about_heading, this.content_heading, this.content_pretext, this.navigator_title_back});

  ProfileData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['stat'] != null) {
      stat = <Stat>[];
      json['stat'].forEach((v) {
        stat!.add(Stat.fromJson(v));
      });
    }
    about = json['about'];
    tagline = json['tagline'];
    imgProfileUrl = json['img_profile_url'];
    imgBackgroundUrl = json['img_background_url'];
    about_heading = json['about_heading'];
    content_heading = json['content_heading'];
    content_pretext = json['content_pretext'];
    navigator_title_back = json['navigator_title_back'];

    //   if (json['content'] != null) {
    //     content = <Content>[];
    //     json['content'].forEach((v) {
    //       content!.add(Content.fromJson(v));
    //     });
    //   }
    // }

    // ignore: unused_element
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = name;
      if (stat != null) {
        data['stat'] = stat!.map((v) => v.toJson()).toList();
      }
      data['about'] = about;
      data['tagline'] = tagline;
      data['img_profile_url'] = imgProfileUrl;
      data['img_background_url'] = imgBackgroundUrl;
      data['about_heading'] = about_heading;
      data['content_heading'] = content_heading;
      data['content_pretext'] = content_pretext;
      data['navigator_title_back'] = navigator_title_back;

      // if (content != null) {
      //   data['content'] = content!.map((v) => v.toJson()).toList();
      // }

      return data;
    }
  }
}
/*
class Content {
  int? index;
  String? file;
  String? title;
  String? simpledesc;
  String? tanggal;

  Content({this.index, this.file, this.title, this.simpledesc, this.tanggal});

  Content.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    file = json['file'];
    title = json['title'];
    simpledesc = json['simpledesc'];
    tanggal = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['file'] = file;
    data['title'] = title;
    data['simpledesc'] = simpledesc;
    data['date'] = tanggal;
    return data;
  }
}
*/
