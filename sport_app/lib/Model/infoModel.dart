import 'dart:convert';

class InfoCategoryModel {
  final int code;
  final String msg;
  final List<InfoCategoryData> data;

  InfoCategoryModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "msg": msg,
      "data": data.map((e) => e.toJson()).toList(),
    };
  }

  factory InfoCategoryModel.fromJson(Map<String, dynamic> json) {
    return InfoCategoryModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'] != null
          ? List<InfoCategoryData>.from(
              json['data'].map((data) => InfoCategoryData.fromJson(data)))
          : [],
    );
  }
}

class InfoCategoryData {
  final int categoryId;
  final String category;

  InfoCategoryData({
    required this.categoryId,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryId": categoryId,
      "category": category,
    };
  }

  factory InfoCategoryData.fromJson(Map<String, dynamic> json) {
    return InfoCategoryData(
      categoryId: json['categoryId'],
      category: json['category'],
    );
  }
}

class InfoListModel {
  final int code;
  final String msg;
  final List<InfoListData> data;

  InfoListModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  factory InfoListModel.fromJson(Map<String, dynamic> json) {
    return InfoListModel(
      code: json['code'],
      msg: json['msg'],
      data: json['data'] != null
          ? List<InfoListData>.from(
              json['data'].map((data) => InfoListData.fromJson(data)))
          : [],
    );
  }
}

class InfoDetailsModel {
  final int code;
  final String msg;
  final InfoListData data;

  InfoDetailsModel({required this.code, required this.msg, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': data,
    };
  }

  factory InfoDetailsModel.fromJson(Map<String, dynamic> json) {
    return InfoDetailsModel(
      code: json['code'],
      msg: json['msg'],
      data: InfoListData.fromJson(json['data']),
    );
  }
}

class InfoListData {
  final int id;
  final int recordId;
  final int categoryId;
  final int type;
  final int sportType;
  final String title;
  final String content;
  final String imgUrl;
  final String popular;
  final int createdDate;

  InfoListData({
    required this.id,
    required this.recordId,
    required this.categoryId,
    required this.type,
    required this.sportType,
    required this.title,
    required this.content,
    required this.imgUrl,
    required this.popular,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "recordId": recordId,
      "categoryId": categoryId,
      "type": type,
      "sportType": sportType,
      "title": title,
      "content": content,
      "imgUrl": imgUrl,
      "popular": popular,
      "createdDate": createdDate,
    };
  }

  factory InfoListData.fromJson(Map<String, dynamic> json) {
    return InfoListData(
      id: json['id'],
      recordId: json['recordId'],
      categoryId: json['categoryId'],
      type: json['type'],
      sportType: json['sportType'],
      title: json['title'],
      content: json['content'],
      imgUrl: json['imgUrl']?? "",
      popular: json['popular'],
      createdDate: json['createdDate'],
    );
  }
}
