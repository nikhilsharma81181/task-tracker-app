import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:task_tracker/model/comment_model.dart';

import '../config/endpoint.dart';

class CommentService {
  Dio dio = Dio();
  Future<List<CommentModel>?> getComments(taskId, token) async {
    try {
      Response res = await dio.get("$endPoint/comment/all/$taskId",
          options: Options(headers: {
            "authorization": token,
          }));
      log(res.data.toString());
      List data = res.data;
      if (data.isNotEmpty) {
        return data.map((e) => CommentModel.fromJson(e)).toList();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<CommentModel?> addComments(String text, taskId, time, token) async {
    try {
      Response res = await dio.post('$endPoint/comment/add',
          data: {
            "text": text,
            "taskId": taskId,
            "time": time,
          },
          options: Options(headers: {
            "authorization": token,
          }));
      log(res.data.toString());
      if (res.statusCode != 200) return null;
      log(res.data.toString());
      return CommentModel.fromJson(res.data);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

    Future<bool> deleteComments(String commentId, token) async {
    try {
      Response res = await dio.delete('$endPoint/comment/$commentId',
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
