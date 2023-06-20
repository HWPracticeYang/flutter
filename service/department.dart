import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> department1(String data) async //依照主科別讓使用者選擇科別,get
{
  var urlStr="http://203.64.84.211:8000/department/list?mainDepartment="+data;
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