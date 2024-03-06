class TapModel {
  late String categoryId;
  late String teamId;
  late int tapCount;
  late double leftPosition;
  late String captainId;
  late String id;
  TapModel({
    required this.leftPosition,
    required this.categoryId,
    required this.teamId,
    required this.tapCount,
    required this.captainId
  });

  TapModel.fromJson(Map<String, dynamic> json) {
        categoryId =  json["categoryId"];
        captainId = json["captainId"];
        teamId = json["teamId"];
        tapCount = json["tapCount"];
        leftPosition = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      "categoryId": categoryId,
      "teamId": teamId,
      "captainId":captainId,
      "tapCount": tapCount
    };
  }
}