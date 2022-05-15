class Character {

  // 'late' keyword is used to tell flutter that
  // a value will be given to that variable later on.

  late int char_id;
  late String name;
  late String nickname;
  late String image;
  late List<dynamic> jobs;
  late String statusIfDeadOrAlive;
  late List<dynamic> appearanceOfSeasons;
  late String actorName;
  late String categoryForTwoSeries;
  late List<dynamic> betterCallSaulAppearance;

  //This method is ued to map each variable to its counterpart
  //in the json response

  Character.fromJson(Map<String, dynamic> json) {
    char_id = json['char_id'];
    name = json['name'];
    nickname = json['nickname'];
    jobs = json['occupation'];
    image = json['img'];
    statusIfDeadOrAlive = json['status'];
    appearanceOfSeasons = json['appearance'];
    actorName = json['portrayed'];
    categoryForTwoSeries = json['category'];
    betterCallSaulAppearance = json['better_call_saul_appearance'];
  }
}