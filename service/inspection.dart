import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> inspection(String identifyName) async //依照檢驗類別名稱查詢檢驗單,使用方法get
 {
  var urlStr="http://203.64.84.211:8000/identify/inspection/list?identifyName="+identifyName;
  Uri uri = Uri.parse(urlStr);
  print(uri);
  http.Response?response;
  try{
    response=await http.get(uri);
  }
  catch(e){
    log(e.toString());
  }
  return response;
}