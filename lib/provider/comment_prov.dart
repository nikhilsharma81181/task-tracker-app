import 'package:flutter/material.dart';
import 'package:task_tracker/model/comment_model.dart';

import '../Services/commets_service.dart';

class CommentProvider extends ChangeNotifier {
  CommentService commentService = CommentService();

  List<CommentModel>? comments = [];

  Future getComments(String taskId, token) async {
    resetCommentsData();
    List<CommentModel>? commentsData =
        await commentService.getComments(taskId, token);

    if (commentsData != null) {
      comments = commentsData;
    } else {
      comments = null;
      notifyListeners();
    }
  }

  Future<bool> addComments(String text, taskId, time, token) async {
    CommentModel? data =
        await commentService.addComments(text, taskId, time, token);
    if (data != null) {
      List<CommentModel> newComment = comments ?? [];
      newComment.add(data);
      comments = newComment;
    }
    return data != null ? true : false;
  }

  Future<bool> deleteComments(String userId, commentId, token ,int index) async {
    bool deleted = await commentService.deleteComments(commentId, token);
    comments!.removeAt(index);
    return deleted;
  }

  resetCommentsData() {
    comments?.clear();
  }
}
