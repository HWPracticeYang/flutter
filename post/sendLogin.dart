import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'package:web/service/btnLogin.dart';
import 'dart:async';

class SendLogin extends ChangeNotifier {
  Future<String> postUser(String acc,String pass) async {   //傳送帳號密碼
    print('postUser:'+acc.toString());
    var jsonResponse;
    try
    {
      http.Response ?response = (await loginSend(acc,pass)); //等待response
      jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態
        print("200");
      }
      else
      {
        print(jsonResponse['status']);  //狀態
        print(jsonResponse['errorMessage']);
        print("err");
      }
    }
    catch(e)
    {
      print("err:"+e.toString());
    }

    return jsonResponse['status'];
  }
}
