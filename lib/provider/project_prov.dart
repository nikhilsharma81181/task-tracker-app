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
    log("step 2");
    if (projectId != "") getProject(userId, token);
    return projectId;
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
