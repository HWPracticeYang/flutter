import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<http.Response?> loginSend(String acc,String pass) async //驗證帳號密碼,使用方法post
 {
   print('acc:'+acc.toString());
   var map = {        //變map的形式
     'nurseId' : acc,
     'password': pass,
   };

    Uri uri = Uri.http('203.64.84.211:8000','nurse/login');
    http.Response?response;
    try{
      response=await http.post(uri,
      headers: {
        "Content-Type": "application/json;charset=UTF-8",  //json檔,傳到server
      },
      body:jsonEncode(map));
    }catch(e){
      log("error"+e.toString());
    }
    return response;
}