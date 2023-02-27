import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_tracker/Services/login_service.dart';

import '../Services/local_storage.dart';

class UserProvider extends ChangeNotifier {
  LoginService loginService = LoginService();
  bool loggedIn = false;
  String userToken = '';
  String userId = '';
  String userName = '';
  String userEmail = '';

  Future<String> logIn(String email, pass) async {
    Response? res = await loginService.logIn(email, pass);
    log(res.toString());
    return processResponse(res);
  }

  Future<String> signUp(String name, email, pass) async {
    log("signUp 2");
    Response? res = await loginService.signUp(name, email, pass);
    return processResponse(res);
  }

  String processResponse(Response? res) {
    log("111;  $res");
    if (res != null &&
        res.data['msg'] != "Invalid" &&
        res.data['msg'] != "User Exists") {
      log(res.toString());
      userToken = res.data['token'];
      userName = res.data['user']['name'];
      userEmail = res.data['user']['email'];
      userId = res.data['user']['_id'];
      SavedSettings.setUserToken(userToken);
      SavedSettings.setUserId(userId);
      SavedSettings.setUserName(userName);
      SavedSettings.setUserEmail(userEmail);
      notifyListeners();
      log("222;  $res");
      return res.data['msg'];
    }
    if (res != null && res.data['msg'] == "User Exists") {
      return "User Exists";
    } else {
      log("Invalid Cred");
      return "Invalid";
    }
  }

  getUserData() {
    userToken = SavedSettings.getUserToken() ?? '';
    userId = SavedSettings.getUserId() ?? '';
    userName = SavedSettings.getUserName() ?? '';
    userEmail = SavedSettings.getUserEmail() ?? '';
    if (userToken != "") loggedIn = true;
    notifyListeners();
  }

  logOut() {
    SavedSettings.setUserToken('');
    SavedSettings.setUserName('');
    SavedSettings.setUserEmail('');
    loggedIn = false;

    notifyListeners();
  }
}
