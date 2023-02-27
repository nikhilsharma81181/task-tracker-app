import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_tracker/config/endpoint.dart';
import 'package:task_tracker/model/task_model.dart';

class TaskService {
  Dio dio = Dio();
  DateTime dateTime = DateTime.now();

  Future<TaskModel?> addTask(
      String projectId, userId, token, name, des, Status status) async {
    try {
      log('$dateTime $userId $projectId $name $des ${status.name} $token');
      Response res = await dio.post('$endPoint/tasks/add',
          data: {
            "userID": userId,
            "projectID": projectId,
            "name": name,
            "desc": des,
            "status": status.name.toString(),
            "duration": 0,
            "initialTime": dateTime.toIso8601String(),
            "endTime": dateTime.toIso8601String()
          },
          options: Options(headers: {
            "authorization": token,
          }));
      log(res.data.toString());
      if (res.statusCode != 200) return null;
      log(res.data.toString());
      return TaskModel.fromJson(res.data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> updateTask(String taskId, token, Status status, bool onlyStatus,
      name, des, duration) async {
    try {
      Map data = onlyStatus
          ? {
              "status": status.name,
            }
          : {
              "name": name,
              "desc": des,
              "duration": duration,
            };
      Response res = await dio.patch('$endPoint/tasks/$taskId',
          data: data,
          options: Options(headers: {
            "authorization": token,
          }));
      log(res.data.toString());
      if (res.statusCode != 200) return false;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteTask(String projectId, token) async {
    try {
      Response res = await dio.delete('$endPoint/tasks/$projectId',
          options: Options(headers: {
            "authorization": token,
          }));
      if (res.statusCode != 200) return false;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<TaskModel>?> getTasks(String projectId, token) async {
    log(projectId.toString());
    try {
      Response res = await Dio().get("$endPoint/tasks/all/$projectId",
          options: Options(headers: {
            "authorization": token,
          }));
      log(res.data.toString());
      List data = res.data;
      if (data.isNotEmpty) {
        return data.map((e) => TaskModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> getCSV(
      String userId, String projectId, token, projectName) async {
    try {
      Response res = await Dio().get("$endPoint/stats/$userId/$projectId",
          options: Options(headers: {
            "authorization": token,
          }));
      if (res.statusCode == 200) {
        log(res.data.toString());
        bool success =
            await saveBase64StringAsFile(projectName, res.data['csv']);
        log(success.toString());
        return success;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveBase64StringAsFile(
      String projectName, String base64String) async {
    String downloadPath = "/storage/emulated/0/Download";
    String name = "$projectName-tasks.csv";
    String newDownloadPath = "$downloadPath/$projectName-tasks.csv";
    final dir = Directory(downloadPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File(newDownloadPath);
    log(name);
    await file.writeAsBytes(base64Decode(base64String));
    log('downloaded');
    return true;
  }
}

enum Status {
  TODO,
  INPROGRESS,
  DONE,
}
