// ignore_for_file: non_constant_identifier_names
class Blocks {
  String? title;
  String? fancy;
  List<BlockItem>? blockItem;

  Blocks({this.title, this.blockItem, this.fancy});

  Blocks.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    fancy = json['fancy'];
    
    if (json['lists'] != null) {
      blockItem = <BlockItem>[];
      json['lists'].forEach((v) {
        blockItem!.add(BlockItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (blockItem != null) {
      data['lists'] = blockItem!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockItem {
  String? timeText;
  String? title;
  String? subtitle;
  String? desc;

  BlockItem({this.timeText, this.title, this.subtitle, this.desc});

  BlockItem.fromJson(Map<String, dynamic> json) {
    timeText = json['time_text'];
    title = json['title'];
    subtitle = json['subtitle'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time_text'] = timeText;
    data['title'] = title;
    data['subtitle'] = subtitle;
    data['desc'] = desc;
    return data;
  }
}

class ProfileData {
  String? name;
  String? about;
  String? tagline;
  String? imgProfileUrl;
  String? imgBackgroundUrl;
  String? about_heading;
  String? content_heading;
  String? content_pretext;
  String? navigator_title_back;
  List<Blocks>? blocks;

  ProfileData(
      {this.name,
      this.about,
      this.tagline,
      this.imgProfileUrl,
      this.imgBackgroundUrl,
      this.about_heading,
      this.content_heading,
      this.content_pretext,
      this.navigator_title_back,
      this.blocks});

  ProfileData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    about = json['about'];
    tagline = json['tagline'];
    imgProfileUrl = json['img_profile_url'];
    imgBackgroundUrl = json['img_background_url'];
    about_heading = json['about_heading'];
    content_heading = json['content_heading'];
    content_pretext = json['content_pretext'];
    navigator_title_back = json['navigator_title_back'];

    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(Blocks.fromJson(v));
      });
    }

    // ignore: unused_element
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['name'] = name;

      data['about'] = about;
      data['tagline'] = tagline;
      data['img_profile_url'] = imgProfileUrl;
      data['img_background_url'] = imgBackgroundUrl;
      data['about_heading'] = about_heading;
      data['content_heading'] = content_heading;
      data['content_pretext'] = content_pretext;
      data['navigator_title_back'] = navigator_title_back;

      data['blocks'] = blocks;
      if (blocks != null) {
        data['blocks'] = blocks!.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
}
