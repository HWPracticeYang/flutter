import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> identifyName(String checkItemList) async //取得檢查項目,使用get
{
  var urlStr="http://203.64.84.211:8000/checkItem/list?identifyName="+checkItemList; //設定url
  Uri uri = Uri.parse(urlStr);  //轉成Uri類型
  print("傳送過來的類別:"+checkItemList);
  http.Response?response;
  try{
    response=await http.get(uri); //await等待回傳
  }catch(e){
    log(e.toString());
  }
  return response;
}