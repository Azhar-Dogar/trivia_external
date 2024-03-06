class GameModel2 {
  late String id;
  late String name;
  late String locationID;
  late List<String> teams;
  late List<String> categories;
  late DateTime dateTime;
  late String status;
  late String hostID;
  String? categoryID;
  int? currentIndex;
  late int roundsCount;
  late int questionsPerRound;
  DateTime? nextTaskTime;
  late int currentRound;
  late Map<String, dynamic> questions;
  String? url;

  GameModel2({
    required this.id,
    required this.locationID,
    required this.teams,
    required this.name,
    required this.categories,
    required this.dateTime,
    required this.roundsCount,
    required this.questionsPerRound,
    this.status = "created",
    required this.hostID,
    this.nextTaskTime,
    this.categoryID,
    this.currentIndex = 0,
    this.currentRound = 1,
    this.questions = const {},
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "locationID": locationID,
      "categories": categories,
      "teams": teams,
      "dateTime": dateTime.millisecondsSinceEpoch,
      "status": status,
      "hostID": hostID,
      "currentIndex": currentIndex,
      "nextTaskTime": nextTaskTime?.microsecondsSinceEpoch,
      "roundsCount": roundsCount,
      "questionsPerRound": questionsPerRound,
      "currentRound": currentRound,
    };
  }

  GameModel2.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    locationID = data["locationID"];
    name = data["name"];
    List teams = data["teams"] ?? [];

    this.teams = List<String>.generate(teams.length, (index) => teams[index]);

    List categories = data["categories"] ?? [];
    this.categories =
        List.generate(categories.length, (index) => categories[index]);
    dateTime = DateTime.fromMillisecondsSinceEpoch(data["dateTime"] ??
        DateTime(2024, 3, 12, 12, 30, 0).millisecondsSinceEpoch);

    status = data["status"] ?? "";
    currentRound = data["currentRound"];
    hostID = data["hostID"];
    categoryID = data["categoryID"];
    currentIndex = data["currentIndex"];

    questionsPerRound = data["questionsPerRound"];
    roundsCount = data["roundsCount"];
    url = data["url"];

    // this.questions = List<RoundQuestion>.generate(questions.length,
    //     (index) => RoundQuestion.fromMap(questions[index])).toList();
    if (data["nextTaskTime"] != null) {
      nextTaskTime = DateTime.fromMillisecondsSinceEpoch(data["nextTaskTime"]);
    }
  }
}
