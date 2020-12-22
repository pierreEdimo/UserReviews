import 'dart:convert';
import 'package:userCritiqs/model/LoginModel.dart';
import 'package:userCritiqs/model/RegisterModel.dart';

import '../main.dart';
import 'package:http/http.dart';

class AuthService {
  Future<int> registerUser(RegisterModel registerModel) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsEncode;
    jsEncode = jsonEncode(registerModel);
    final Response response = await post(
        'https://uservoice20201218092231.azurewebsites.net/api/User/Register',
        headers: headers,
        body: jsEncode);

    if (response.statusCode == 200) {
      String jwt = response.body;
      storage.write(key: "jwt", value: jwt);
    } else {
      throw "Error";
    }

    return response.statusCode;
  }

  Future<int> loginUser(LoginModel loginModel) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsEncode;
    jsEncode = jsonEncode(loginModel);
    final Response response = await post(
        'https://uservoice20201218092231.azurewebsites.net/api/User/Login',
        headers: headers,
        body: jsEncode);

    if (response.statusCode == 200) {
      String jwt = response.body;
      storage.write(key: "jwt", value: jwt);
    } else {
      throw "error";
    }

    return response.statusCode;
  }

  Future<RegisterModel> fetchSingleUser() async {
    String authorization = await storage.read(key: "jwt");
    final Response response = await get(
        'https://uservoice20201218092231.azurewebsites.net/api/User/GetUser',
        headers: {'Authorization': 'Bearer ' + authorization});

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      storage.write(key: "userId", value: responseJson['id']);
      print(responseJson['id']);
      return RegisterModel.fromJson(responseJson);
    }
    return null;
  }
}
