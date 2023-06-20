import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'dart:async';
import 'package:web/chooseBtn.dart';
import 'package:web/service/inspection.dart';

var count=0;
class DataClass3 extends ChangeNotifier { //查詢檢驗單
  bool loading = false;
  bool isBack = false;
  Future<List> getSchedule(String data) async {
    print("查詢檢驗單");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await inspection(data)); //等待response
      jsonResponse=json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print('狀態:'+jsonResponse['status']);  //狀態碼
        print(jsonResponse['inspectionList']);
        count=jsonResponse['inspectionList'].length;  //回傳有幾筆資料
        print('有幾筆資料:'+count.toString());
        print('狀態碼:'+"200");
        isBack = true;
      }
      else
      {
        print('狀態:'+jsonResponse['status']);  //狀態碼
        print(jsonResponse['errorMessage']);
        print("err");
      }
      loading = false;
      notifyListeners();
    }
    catch(e)
    {
      print("err:"+e.toString());
    }
    return jsonResponse['inspectionList'];
  }
}