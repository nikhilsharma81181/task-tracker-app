import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_tracker/Services/project_service.dart';
import 'package:task_tracker/model/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  ProjectService projectService = ProjectService();
  bool noProjects = true;

  List<ProjectModel>? projects = [];

  Future getProject(String userId, token) async {
    List<ProjectModel>? projectData =
        await projectService.getProject(userId, token);
    projects = projectData;
    notifyListeners();
  }

  Future<String> createProject(String userId, token, name, colorCode) async {
    String projectId =
        await projectService.createProject(userId, token, name, colorCode);
    if (projectId != "") getProject(userId, token);
    return projectId;
  }

  Future<bool> deleteProject(String projectId, token, userId) async {
    bool deleted = await projectService.deleteProject(projectId, token);
    getProject(userId, token);
    return deleted;
  }

  Future<bool> updateProject(
      String projectId, token, userId, name, color) async {
    bool updated =
        await projectService.updateProject(projectId, token, name, color);
    getProject(userId, token);
    return updated;
  }

  // Color Option Picker
  int selectedColorIndex = 0;

  void selectColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void resetColor() {
    selectedColorIndex = 0;
    notifyListeners();
  }
}
