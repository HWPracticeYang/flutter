import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> doctor1(String data) async //依照科別編號查醫生,使用方法get
{
  var urlStr="http://203.64.84.211:8000/doctor/list?departmentNum="+data;
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