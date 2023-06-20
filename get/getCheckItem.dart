import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'dart:async';
import 'package:web/service/identifyName.dart';

var count=0;
class DataClass2 extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;

  Future<List> getData(String data) async {
    print("getData");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await identifyName(data)); //等待response
      jsonResponse=convert.jsonDecode(response!.body);
      if (response.statusCode == 200) {
        print(jsonResponse['status']);      //狀態碼
        print(jsonResponse['data']);
        count=jsonResponse['data'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);      //狀態碼
        print(jsonResponse['data']);
        print("err");
      }
      loading = false;
      notifyListeners();
    }
    catch(e)
    {
      print("err:"+e.toString());

    }
    return jsonResponse['data'];
  }
}