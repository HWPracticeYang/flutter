import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'package:web/service/btn.dart';
import 'package:web/model/inspection.dart';
import 'dart:async';

class Send extends ChangeNotifier {
  Future<void> postData(inspection1 data) async {   //傳送檢驗單內容
    print("post檢驗單");
    print(data);
    var jsonResponse;
    try
    {
      http.Response ?response = (await btnSend(data)); //等待response
      jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['data']);
        print("200");
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['data']);
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
