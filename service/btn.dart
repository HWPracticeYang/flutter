import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web/model/inspection.dart';

Future<http.Response?> btnSend(inspection1 data) async  //新增檢驗單資料到資料庫,使用方法是post
{
  print("identifyName"+data.identifyName);
  Uri uri = Uri.http('203.64.84.211:8000','inspection/add');
  print(uri);
  http.Response?response;
  try{
    response=await http.post(uri,
        headers: {
          "Content-Type":"application/json;charset=UTF-8"  //json檔,傳到server
        },
        body:jsonEncode(data));
  }
  catch(e){
    log(e.toString());
  }
  return response;
}