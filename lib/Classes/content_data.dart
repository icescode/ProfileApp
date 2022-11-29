class ContentDataClass {
  List<Content>? content;

  ContentDataClass({this.content});

  ContentDataClass.fromJson(Map<String, dynamic> json) {
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int? index;
  String? fileurl;
  String? file;
  String? title;
  String? simpledesc;
  String? date;

  Content({this.index, this.fileurl, this.file, this.title, this.simpledesc, this.date});

  Content.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    fileurl = json['fileurl'];
    file = json['file'];
    title = json['title'];
    simpledesc = json['simpledesc'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['index'] = index;
    data['fileurl'] = fileurl;
    data['file'] = file;
    data['title'] = title;
    data['simpledesc'] = simpledesc;
    data['date'] = date;
    return data;
  }
}
