import 'dart:convert';

List<ProjectModel> projectModelFromJson(String str) => List<ProjectModel>.from(
    json.decode(str).map((x) => ProjectModel.fromJson(x)));

String projectModelToJson(List<ProjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectModel {
  ProjectModel({
    required this.id,
    required this.name,
    required this.des,
    required this.color,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  String id;
  String name;
  String des;
  String color;
  String user;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["_id"],
        name: json["name"],
        des: json["des"],
        color: json["color"],
        user: json["user"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "des": des,
        "color": color,
        "user": user,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
