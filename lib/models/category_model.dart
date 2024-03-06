 import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CategoryModel{
  late String photo;
  late String thumbUrl;
  late String id;
  late String name;
  late int tapCount;
  Gradient? gradient;
  CategoryModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.photo,
    required this.tapCount,
    this.gradient
 });
  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    thumbUrl = json["thumb_url"];
    photo = json["photo"];
    tapCount = json["tapCount"]??0;
  }
}