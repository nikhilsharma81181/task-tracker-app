import 'dart:async';
import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  TaskModel({
    required this.id,
    required this.name,
    required this.desc,
    required this.projectId,
    required this.user,
    required this.status,
    required this.duration,
    required this.initialTime,
    required this.endTime,
    required this.v,
    required this.isActive,
    required this.taskTimer,
    required this.updateTimer,
  });

  String id;
  String name;
  String desc;
  String projectId;
  String user;
  String status;
  int duration;
  DateTime initialTime;
  int endTime;
  int v;
  bool isActive;
  Timer taskTimer;
  Timer updateTimer;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["_id"],
        name: json["name"],
        desc: json["desc"],
        projectId: json["projectID"],
        user: json["user"],
        status: json["status"],
        duration: json["duration"],
        initialTime: DateTime.parse(json["initialTime"]),
        endTime: json["endTime"],
        v: json["__v"],
        isActive: json["isActive"],
        taskTimer: Timer.periodic(const Duration(seconds: 0), (timer) {}),
        updateTimer: Timer.periodic(const Duration(seconds: 0), (timer) {}),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "desc": desc,
        "projectID": projectId,
        "user": user,
        "status": status,
        "duration": duration,
        "initialTime": initialTime.toIso8601String(),
        "endTime": endTime,
        "__v": v,
        "isActive": isActive,
        "taskTimer": taskTimer,
        "updateTimer": updateTimer,
      };
}
