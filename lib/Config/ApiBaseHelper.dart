import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';

import 'package:quick_pay/Config/common.dart';


import 'constant.dart';
String token="123";
class ApiBaseHelper {

  Future<dynamic> postAPICall(Uri url, var param) async {
    await App.init();
    if(App.localStorage.getString("user_id")!=null){
      token = App.localStorage.getString("user_id").toString();
    }

    var responseJson;
    try {
      debugPrintApp(
          "API : $url \n parameter : $param   \n ");
      final response = await post(url,
          body: param,headers: {
           // 'Content-Type': 'application/json',
             'Accept': '*/*',
              'Cookie': 'ci_session=a346d453efea89630b4f4a4fd3dc0b76e24b6f50',
             //'Content-Type':'application/x-www-form-urlencoded',
             'authorization':token.toString(),
          })
          .timeout(Duration(seconds: timeOut));

      debugPrintApp(
          "API : $url \n parameter : ${param}  \n header: ${{
            'authorization':token.toString(),
          }}\n response:  ${response.body.toString()} ");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }
  Future<dynamic> patchAPICall(Uri url, var param) async {
    await App.init();
    if(App.localStorage.getString("user_id")!=null){
      token = App.localStorage.getString("user_id").toString();
    }
    var responseJson;
    try {
      debugPrintApp(
          "API : $url \n parameter : $param   \n ");
      final response = await patch(url,
          body: param,headers: {
            'Content-Type': 'application/json',
            // 'Accept': '*/*',
             //'Content-Type':'application/x-www-form-urlencoded',
            'authorization':token.toString(),
          })
          .timeout(Duration(seconds: timeOut));
     /* debugPrintApp(
          "API : $url \n parameter : ${param}   \n response:  ${response.body.toString()}yuj ");*/
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }
  Future<dynamic> getAPICall(Uri url) async {
    await App.init();
    if(App.localStorage.getString("user_id")!=null){
       token = App.localStorage.getString("user_id").toString();
    }

    var responseJson;
    try {
      /*debugPrintApp(
          "API : $url \n parameter :    \n ");*/
      final response = await get(url,
          headers: {
            'Content-Type': 'application/json',
           // 'Content-Type':'application/x-www-form-urlencoded',
            'authorization':token.toString(),
          })
          .timeout(Duration(seconds: timeOut));

      debugPrintApp(
          "API : $url \n Headers : ${{
            'Content-Type':'application/x-www-form-urlencoded',
            'authorization':token.toString(),
          }}   \n response:  ${response.body.toString()}yuj ");
      responseJson = _response(response);
    } on SocketException {

      return 'No Internet connection';
    } on TimeoutException {
      return 'Something went wrong, try again later';
    }
    return responseJson;
  }
  Future<dynamic> deleteAPICall(Uri url) async {
    await App.init();
    if(App.localStorage.getString("token")!=null){
      token = App.localStorage.getString("token").toString();
    }

    var responseJson;
    try {
      debugPrintApp(
          "API : $url \n parameter :    \n ");
      final response = await delete(url,
          headers: {
            'Content-Type': 'application/json',
           // 'Content-Type':'application/x-www-form-urlencoded',
            'authorization':"Bearer "+token.toString(),
          })
          .timeout(Duration(seconds: timeOut));
      debugPrintApp(
          "API : $url \n Headers : ${{
            'Accept': '*/*',
            'Content-Type':'application/x-www-form-urlencoded',
            'authorization':curUserId.toString(),
          }}   \n response:  ${response.body.toString()}yuj ");
      responseJson = _response(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on TimeoutException {
      throw FetchDataException('Something went wrong, try again later');
    }
    return responseJson;
  }
  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 401:
      case 403:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 500:
      default:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
    }
  }
}

class CustomException implements Exception {
  final _message;
  final _prefix;
  CustomException([this._message, this._prefix]);
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
