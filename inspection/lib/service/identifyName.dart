import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> identifyName(String data) async
{
  var map = {
    'identifyName' : data
  };
  Uri uri = Uri.http('203.64.84.211:8080','checkItem');
  print(uri);
  http.Response?response;
  try{
    response=await http.post(uri,
        headers: {
          "Content-Type": "application/json;charset=UTF-8",  //json檔,傳到server
        },
        body:jsonEncode(map));
  }catch(e){
    log(e.toString());
  }
  return response;
}