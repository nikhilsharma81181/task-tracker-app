import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:task_tracker/model/project_model.dart';

import '../config/endpoint.dart';

class ProjectService {
  Future<String> createProject(String userId, token, name, colorCode) async {
    try {
      Response res = await Dio().post("$endPoint/projects/create",
          data: {
            "name": name,
            "des": 'Des',
            "color": colorCode,
            "userID": userId,
          },
          options: Options(headers: {
            "authorization": token,
          }));
      log("step 2");
      if (res.statusCode != 200) return "";
      log(res.data.toString());
      return res.data['_id'];
    } catch (e) {
      return "";
    }
  }

  Future<List<ProjectModel>?> getProject(String userId, token) async {
    try {
      Response res = await Dio().get("$endPoint/projects/all/$userId",
          options: Options(headers: {
            "authorization": token,
          }));
      List data = res.data;
      if (data.isNotEmpty) {
        return data.map((e) => ProjectModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteProject(String projectId, token) async {
    try {
      Response res = await Dio().delete('$endPoint/projects/$projectId',
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

  Future<bool> updateProject(String projectId, token, name, color) async {
    try {
      Response res = await Dio().patch('$endPoint/projects/$projectId',
          data: {
            "name": name,
            "color": color,
          },
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
}
