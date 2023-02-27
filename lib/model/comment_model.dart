import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(json.decode(str).map((x) => CommentModel.fromJson(x)));

String commentModelToJson(List<CommentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
    CommentModel({
        required this.id,
        required this.text,
        required this.taskId,
        required this.time,
        required this.v,
    });

    String id;
    String text;
    String taskId;
    DateTime time;
    int v;

    factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json["_id"],
        text: json["text"],
        taskId: json["taskId"],
        time: DateTime.parse(json["time"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "taskId": taskId,
        "time": time.toIso8601String(),
        "__v": v,
    };
}
