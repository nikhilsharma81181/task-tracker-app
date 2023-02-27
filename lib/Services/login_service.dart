import 'dart:developer';

import 'package:dio/dio.dart';

import '../config/endpoint.dart';

class LoginService {
  final dio = Dio();

  Future<Response?> logIn(String email, pass) async {
    try {
      log("cred  $email $pass");
      Response res = await dio.post("$endPoint/user/login", data: {
        "email": email,
        "pass": pass,
      });
      log(res.data.toString());
      return res;
    } catch (e) {
      return null;
    }
  }

  Future<Response?> signUp(String name, email, pass) async {
    try {
      log("signUp 1 $name, $email, $pass");
      Response res = await Dio().post("$endPoint/user/register", data: {
        "name": name,
        "email": email,
        "pass": pass,
      });
      log("signUp 11");
      log(res.data.toString());
      log("signUp 111");
      return res;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
