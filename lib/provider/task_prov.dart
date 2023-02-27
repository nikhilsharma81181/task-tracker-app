import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_tracker/Services/task_service.dart';
import 'package:task_tracker/model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  TaskService taskService = TaskService();

  List<TaskModel>? tasks = [];
  List<TaskModel>? toDoTasks = [];
  List<TaskModel>? inProgressTasks = [];
  List<TaskModel>? doneTasks = [];

  Timer? taskTimer;
  Timer? updateTimer;
  int taskDuration = 0;

  Future getProject(projectId, token) async {
    resetTaskData();
    List<TaskModel>? taskData = await taskService.getTasks(projectId, token);

    if (taskData != null) {
      tasks = taskData;
      for (var i = 0; i < taskData.length; i++) {
        addToFollowingStatus(taskData[i]);
        notifyListeners();
      }
    } else {
      tasks = null;
      notifyListeners();
    }
  }

  Future<bool> addTask(
      String projectId, userId, token, name, des, Status status) async {
    TaskModel? data =
        await taskService.addTask(projectId, userId, token, name, des, status);
    if (data != null) {
      List<TaskModel> newTasks = tasks ?? [];
      newTasks.add(data);
      tasks = newTasks;
      addToFollowingStatus(data);
    }
    return data != null ? true : false;
  }

  Future<bool> updateTask(String taskId, token, Status status, bool onlyStatus,
      name, des, int duration) async {
    bool added = await taskService.updateTask(
        taskId, token, status, onlyStatus, name, des, duration);
    return added;
  }

  Future<bool> deleteTask(String projectId, token) async {
    bool deleted = await taskService.deleteTask(projectId, token);

    return deleted;
  }

  addToFollowingStatus(taskData) {
    switch (taskData.status) {
      case "TODO":
        toDoTasks!.add(taskData);
        break;
      case "INPROGRESS":
        inProgressTasks!.add(taskData);
        break;
      case "DONE":
        doneTasks!.add(taskData);
        break;
      default:
    }
  }

  resetTaskData() {
    tasks!.clear();
    toDoTasks!.clear();
    inProgressTasks!.clear();
    doneTasks!.clear();
  }

  void startTimer(
    List<TaskModel> tasks,
    TaskModel activeTask,
    String taskId,
    token,
  ) {
    for (var i = 0; i < tasks.length; i++) {
      TaskModel task = tasks[i];
      if (task.id == taskId) {
        // Activate the selected task
        if (!task.isActive) {
          // Start the timer
          task.taskTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (activeTask == task) {
              task.duration++;
              notifyListeners();
            }
          });

          // update task duration in every 5 seconds
          task.updateTimer =
              Timer.periodic(const Duration(seconds: 5), (timer) {
            updateTask(task.id, token, Status.DONE, false, task.name, task.desc,
                task.duration);
          });

          task.isActive = true;
        }
      } else {
        // Deactivate other tasks
        if (task.isActive) {
          task.taskTimer.cancel();
          task.updateTimer.cancel();
          task.isActive = false;
          notifyListeners();
        }
      }
    }
  }

  stopTimer(TaskModel task) {
    task.isActive = false;
    task.taskTimer.cancel();
    task.updateTimer.cancel();
    notifyListeners();
  }
}
