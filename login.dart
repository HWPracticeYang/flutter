import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/post/sendLogin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web/main.dart';
int jud=1;
var status;
TextEditingController Acc = TextEditingController();
TextEditingController Password = TextEditingController();

void page1() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Login(),
  );
}

class Login extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        backgroundColor:const Color(0xfff3f0e2),
        appBar: AppBar(
          title:Image.asset('lib/assets/logo.png',width:200,),
          backgroundColor:const Color(0xff6c98c6),
        ),
        body:Center(
          child:SizedBox(
            width:400,
            height:400,
            child:Card(
              child:Container(
                child: MyForm(),
                margin: EdgeInsets.only(left: 50,top:50,right: 50,bottom:10),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyForm extends StatefulWidget{
  const MyForm({key});
  @override
  State<StatefulWidget> createState(){
    return _MyForm();
  }
}

class _MyForm extends State<MyForm>{
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        TextField(          //輸入acc
          controller: Acc,
          decoration: InputDecoration(
            labelText:'帳號',
          ),
          maxLength:10,
        ),
        TextField(           //輸入password
          controller: Password,
          obscureText: true,
          decoration: InputDecoration(
            labelText:'密碼',
          ),
        ),
        Padding(
          padding:EdgeInsets.only(left:40,top:80),
        ),
        Column(
          children: [
            Center(
              child:btn(),
            )
          ],
        )
      ],
    );
  }
}

class btn extends StatefulWidget{
  const btn({key});
  @override
  State<StatefulWidget> createState(){
    return _btn();
  }
}

class _btn extends State<btn> with ChangeNotifier{
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
         InkWell(
             child: Column(
               children: [
                 Padding(padding: const EdgeInsets.all(5),
                     child: Icon(Icons.login_rounded)),
                 Text('登入'),
               ],
             ),
             highlightColor: Color(0xffB0F2B4), // 設置水波纹效果的高亮颜色
             splashColor:Color(0xffBAF2E9), // 設置水波纹效果的溅射颜色
             onTap: () {
               setState(() {
                 status=SendLogin().postUser(Acc.text.toString(),Password.text.toString()); //傳acc和password
                 status.then((value){   //打開future取值
                   print("nurseId:"+value.toString());
                   if(value=='Fail'){
                     jud=0;
                     Acc.text="";
                     Password.text="";
                     return showDialog(
                         context: context,
                         builder: (context) {
                           return AlertDialog(
                             title: Text('錯誤'),
                             content: Text('帳號或密碼輸入錯誤'),
                             actions: [
                               TextButton(
                                 child: Text("ok"),
                                 onPressed: () => Navigator.of(context).pop(), // 關閉對話框
                               ),
                             ],
                           );
                         }
                     );
                   }
                   else{
                     jud=1;
                     Fluttertoast.showToast(
                       msg: "送出成功",
                       toastLength:Toast.LENGTH_SHORT,
                       textColor: Color(0xfff7e0cd),
                     );
                     if(jud==1){  //登入成功,跳頁
                       Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
                       Acc.text="";
                       Password.text="";
                     }
                   }
                 });
               }

               );
             }

         ),

     ],
   );
  }
}