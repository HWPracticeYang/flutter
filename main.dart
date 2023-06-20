import 'dart:convert';
import 'dart:html';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web/login.dart';
import 'package:web/main.dart';
import 'package:web/service/doctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'dart:async';
import 'package:web/service/identifyName.dart';
import 'package:web/get/getCheckItem.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:web/service/department.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:web/model/inspection.dart';
import 'package:web/postData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web/chooseBtn.dart';
import 'package:web/login.dart';

TextEditingController inspectionNum = TextEditingController();
TextEditingController ID = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController doctor = TextEditingController();
var statu;
bool haserror=false;
enum identify{SONO,CT,MRI,BMD,Xray,none}
enum department{Medicine,surgery, specialist,none}
String? selectedValue;
String? selectedValue2;
identify?_identify;
department?_department;
var selectdepartment="-1";
var selectidentify="-1";
List L=[];
late Future<List<dynamic>> list;
late Future<List<dynamic>> Dlist;
late Future<List<dynamic>> DocList;
class inspection{ //檢驗類別
  final String identifyNum;
  final String name;

  inspection(
      this.identifyNum,
      this.name,
  );
}

class alldepartment{  //科別
  final String departmentName;
  final String departmentNum;

  alldepartment(
      this.departmentName,
      this.departmentNum,
  );
}

class alldoctor{  //醫生
  final String doctorName;
  final String doctorNum;

  alldoctor(
      this.doctorName,
      this.doctorNum,
  );
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();//初始化
  runApp(
      MultiProvider(  //多狀態同時管理
        providers: [  //使用provider方便傳遞到其他底層頁面
          ChangeNotifierProvider<Send>(
            create: (context) => Send(),
          ),
        ],
        child:Login(),
      )
  );
}
class home extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      initialRoute: '/', //設定初始頁面為首頁
      routes: {   //指定routes,換頁
        '/': (context) => Web(),
        '/schedule':(context)=> schedule(),
        '/leave':(context)=> Login(),
      },
    );
  }
}
class Web extends StatelessWidget{  //側邊選單
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
        drawer: Drawer(     //建立menu選單
          child: ListView(  //添加像列表一樣的選單內容
            padding:EdgeInsets.zero,
            children: [
              ListTile(
                  leading:Icon(Icons.add),
                  title: Text('新增檢驗單'),
                  onTap: (){  //點擊後做的事
                    Navigator.popAndPushNamed(context,'/'); //切換頁面
                  },
                hoverColor:Color(0xffDCE1F0),
                selectedColor:Color(0xff7A82AB),
                selected:true,
              ),
              ListTile(
                  leading:Icon(Icons.alarm_on_rounded),
                  title: Text('顯示排程'),
                  onTap:(){   //點擊後做的事
                    Navigator.popAndPushNamed(context,'/schedule'); //切換頁面
                  },
                hoverColor:Color(0xffDCE1F0),
                selectedColor:Color(0xff7A82AB),
                selected:true,
              ),
              ListTile(
                leading:Icon(Icons.ac_unit_outlined),
                title: Text('登出'),
                onTap:(){ //點擊後做的事
                  Navigator.popAndPushNamed(context,'/leave'); //切換頁面
                },
                hoverColor:Color(0xffDCE1F0),
                selectedColor:Color(0xff7A82AB),
                selected:true,
              ),
            ],
          ),
        ),
        body:Center(
          child:SizedBox(
            width:500,
            child:Card(
              child:Container(
                child: MyForm(),
                margin: EdgeInsets.only(left: 50,top:10,right: 50,bottom:10),
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
class _MyForm extends State<MyForm> {
  @override
  Widget build(BuildContext context) {
    return   ListView(
          children:<Widget> [
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            TextField(    //輸入ID
              controller: ID,
              decoration: InputDecoration(
              labelText:'身分證號',
              ),
              maxLength:10, //最大長度10
              maxLengthEnforcement:MaxLengthEnforcement.enforced, //達到最大長度時,會阻止輸入
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            TextField(    //輸入檢驗單單號
              controller: inspectionNum,
              decoration: const InputDecoration(
              labelText:'檢驗單單號',
              ),
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            Column(     //選檢驗類別
              children:const [
                Center(
                  child: chooses(),
                ),
              ],
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:5),
            ),
          ],
    );
  }
 }

class chooses extends StatefulWidget{
  const chooses({key});
  @override
  State<StatefulWidget> createState(){
    return _chooses();
  }
}

class _chooses extends State<chooses> with ChangeNotifier{
  List<MultiSelectItem<alldepartment>> _items2 = [];
  final List<alldepartment> _alldepartment = [];
  List<MultiSelectItem<alldoctor>> _doctors = [];
  final List<alldoctor> _alldoctor = [];
  late DateTime selectDate;
  List<MultiSelectItem<inspection>> _items = [];  //檢驗項目
  final List<inspection> _inspection = [];  //檢驗項目List
  List<inspection> _selectInspection = [];  //選擇的檢驗項目
  List<MultiSelectItem<inspection>> empty = [];
  bool loading = false;
  bool isBack = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children:<Widget> [
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            Row(
              children: [
                Text("類別:",style: TextStyle(fontSize:16)),
                Radio<identify>(                  //建立radio選項(SONO)
                  value:identify.SONO,            //設定顯示的值
                  activeColor:Color(0xff6c98c6),  //選中的顏色
                  groupValue: _identify,
                  onChanged:(identify? value){    //選項改變
                    _items.clear();               //清空檢驗項目
                    _inspection.clear();          //清空新增到檢驗項目的list
                    _selectInspection.clear();    //清空選擇的檢驗項目
                    selectidentify="SONO";
                    list=getData(selectidentify); //傳SONO
                    list.then((value){            //打開Future取值,_inspection放好值後,變成selectItem
                      for(int i = 0; i < value.length; i++){
                        _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                      }
                      _items = _inspection.map((inspection e) => MultiSelectItem<inspection>(e, e.name)).toList();
                    });
                    setState(() {                 //刷新頁面
                      _identify=value;
                    });
                  },
                ),
                Text("SONO",style: TextStyle(fontSize:16)),
                Radio<identify>(                  //建立radio選項(CT)
                  value: identify.CT,
                  activeColor:Color(0xff6c98c6),
                  groupValue: _identify,
                  onChanged:(identify? value){
                    _items.clear();
                    _inspection.clear();
                    _selectInspection.clear();
                    selectidentify="CT";
                    list=getData(selectidentify); //傳CT
                    print(list);
                    list.then((value){
                      for(int i = 0; i < value.length; i++){
                        // print(value.length);
                        // print(value[i]['checkItemNum']);
                        _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                      }
                      _items = _inspection.map((e) => MultiSelectItem<inspection>(e, e.name)).toList(); //轉成selectItem
                    });
                    setState(() {
                      _identify=value;
                    });
                  },
                ),
                Text("CT",style: TextStyle(fontSize:16)),
                Radio<identify>(
                  value: identify.MRI,
                  activeColor:Color(0xff6c98c6),
                  groupValue: _identify,
                  onChanged:(identify? value){
                    _items.clear();
                    _inspection.clear();
                    _selectInspection.clear();
                    selectidentify="MRI";
                    list=getData(selectidentify);
                    list.then((value){
                      for(int i = 0; i < value.length; i++){
                        print(value.length);
                        print(value[i]['checkItemNum']);
                        _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                      }
                      _items = _inspection.map((e) => MultiSelectItem<inspection>(e, e.name)).toList();
                    });
                    setState(() {
                      _identify = value;
                    });
                  },
                ),
                Text("MRI",style: TextStyle(fontSize:16)),
                Radio<identify>(
                  value: identify.BMD,
                  activeColor:Color(0xff6c98c6),
                  groupValue: _identify,
                  onChanged:(identify? value)  {
                    _items.clear();
                    _inspection.clear();
                    _selectInspection.clear();
                    selectidentify="BMD";
                    list = getData(selectidentify);
                    print(list);
                    list.then((value){
                      for(int i = 0; i < value.length; i++){
                        // print(value.length);
                        // print(value[i]['checkItemNum']);
                        _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                      }
                      _items = _inspection.map((e) => MultiSelectItem<inspection>(e, e.name)).toList();
                    });
                    setState(()  {
                      _identify=value;
                    });//end of setState
                  },
                ),
                Text("BMD",style: TextStyle(fontSize:16)),
                Radio<identify>(
                  value: identify.Xray,
                  activeColor:Color(0xff6c98c6),
                  groupValue: _identify,
                  onChanged:(identify? value)  {
                    _items.clear();
                    _inspection.clear();
                    _selectInspection.clear();
                    selectidentify="X-Ray";
                    list = getData(selectidentify);
                    print(list);
                    list.then((value){
                      for(int i = 0; i < value.length; i++){
                        _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                      }
                      _items = _inspection.map((e) => MultiSelectItem<inspection>(e, e.name)).toList();
                    });
                    setState(()  {
                      _identify=value;
                    });//end of setState
                  },
                ),
                Text("X光",style: TextStyle(fontSize:16)),
              ],
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Text("檢驗項目:", style: TextStyle(fontSize:16)),
                  ],
                ),
                MultiSelectDialogField<inspection>( //選檢驗項目編號
                  searchable: true,   //可搜尋
                  items:_items,
                  title: Text("檢驗項目&編號",style:TextStyle(fontSize:16)),
                  listType: MultiSelectListType.LIST,
                  backgroundColor:Color(0xfff3f0e2),
                  selectedColor:Color(0xff6c98c6),
                  onConfirm: (values) {
                    // print("value");
                    // print(values);
                    _selectInspection = values;
                    L.clear();
                    // print("List");
                    // print(L);
                    _selectInspection.forEach((element) { //checkItemNumList
                      print("選擇的檢驗項目:"+element.identifyNum);
                      L.add(element.identifyNum);
                    });
                  },
                ),
              ],
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(         //選擇開單日期
                      width: 250,
                      child: TextField(
                        controller: date,
                        enabled: false,
                        decoration: InputDecoration(
                          labelText:'開單日期',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async{
                        var result = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022,01),   //可選最早日期
                            lastDate: DateTime.now(),       //可選最晚日期
                            selectableDayPredicate: (DateTime day){
                              return day.difference(DateTime.now()).inDays < 1;
                            },
                            builder: (context, widget){
                              return Theme(data: ThemeData.dark(), child: widget!);
                            }
                        );
                        if(result != Null){
                          setState(() {
                            date.text = formatDate(result!, ['yyyy','/','mm','/','dd']);
                          });
                        }
                      },
                      icon: const Icon(Icons.date_range),
                    ),
                  ],
                )
              ],
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            Column(
              children: [
                Row(  //建主科別的radio
                  children: [
                    Text("主科別:",style: TextStyle(fontSize:16)),
                    Radio<department>(
                      value: department.Medicine,
                      activeColor:Color(0xff6c98c6),
                      groupValue: _department,
                      onChanged:(department? value){
                        _items2.clear();
                        _alldepartment.clear(); //清空科別
                        _alldoctor.clear();     //清空醫生
                        selectdepartment="內科系";
                        Dlist=getDepartment(selectdepartment);  //依照主科別讓使用者選擇科別
                        Dlist.then((value){   //打開future的值,新增到_alldepartment
                          for(int j=0;j<value.length;j++){
                            _alldepartment.add(alldepartment(value[j]['departmentNum'].toString(),"["+value[j]['departmentNum'].toString()+"] "+value[j]['departmentName'].toString(),));
                          }
                          //print(_alldepartment);
                        });
                        setState(() {
                          _department=value;
                          selectedValue = null;
                          selectedValue2=null;
                        });
                      },
                    ),
                    Text("內科別",style: TextStyle(fontSize:16)),
                    Radio<department>(
                      value: department.surgery,
                      activeColor:Color(0xff6c98c6),
                      groupValue: _department,
                      onChanged:(department? value){
                        _items2.clear();
                        _alldepartment.clear();
                        _alldoctor.clear();
                        selectdepartment="外科系";
                        Dlist=getDepartment(selectdepartment);
                        Dlist.then((value){
                          for(int j=0;j<value.length;j++){
                            print(value.length);
                            print(value[j]['departmentNum']);
                            _alldepartment.add(alldepartment(value[j]['departmentNum'].toString(),"["+value[j]['departmentNum'].toString()+"] "+value[j]['departmentName'].toString(),));
                          }
                          print(_alldepartment);
                        });
                        setState(() {
                          _department=value;
                          selectedValue = null;
                          selectedValue2=null;
                        });
                      },
                    ),
                    Text("外科別",style: TextStyle(fontSize:16)),
                    Radio<department>(
                      value: department.specialist,
                      activeColor:Color(0xff6c98c6),
                      groupValue: _department,
                      onChanged:(department? value){
                        _items2.clear();
                        _alldepartment.clear();
                        _alldoctor.clear();
                        selectdepartment="各專科";
                        Dlist=getDepartment(selectdepartment);
                        Dlist.then((value){
                          for(int j=0;j<value.length;j++){
                            print(value.length);
                            print(value[j]['departmentNum']);
                            _alldepartment.add(alldepartment(value[j]['departmentNum'].toString(),"["+value[j]['departmentNum'].toString()+"] "+value[j]['departmentName'].toString(),));
                          }
                          print(_alldepartment);
                        });
                        setState(() {
                          _department=value;
                          selectedValue = null; //清空科別
                          selectedValue2=null;  //清空醫生編號
                        });
                      },
                    ),
                    Text("各專科",style: TextStyle(fontSize:16)),
                  ],
                )
              ],
            ),
            const Padding(
              padding:EdgeInsets.only(bottom:20),
            ),
            viewDepartment(),
            Padding(
              padding:EdgeInsets.only(left:40,top:80),
              child:ElevatedButton(
                onPressed:()async{
                  bool?ok=await validation(ID.text);
                  if(haserror==false){
                    setState(() {
                      //輸入的內容儲存到model
                      inspection1 Inspection=inspection1(userId:ID.text, inspectionNum: inspectionNum.text, identifyName: selectidentify.toString(), billingDate: date.text.toString(), doctorNum: selectedValue2.toString(), checkItemNumList:L);
                      var provider = Provider.of<Send>(context, listen: false);
                   //   var value;
                      statu=provider.postData(Inspection);  //傳送檢驗單內容
                      statu.then((value){
                        print("檢驗單:"+value);
                        if(value=='Fail'){
                          Fluttertoast.showToast(
                            msg: "送出失敗",
                            toastLength:Toast.LENGTH_SHORT,
                            textColor: Color(0xfff7e0cd),
                          );
                        }
                        else{
                          Fluttertoast.showToast(
                            msg: "送出成功",
                            toastLength:Toast.LENGTH_SHORT,
                            textColor: Color(0xfff7e0cd),
                          );
                        }
                      });
                      ID.text=""; //clear 身分證
                      _identify=identify.none;  //clear 類別
                      _department=null; //clear 主科別
                      _alldepartment.clear(); //clear 科別
                      _alldoctor.clear(); //clear 醫生
                      inspectionNum.text="";
                      _items.clear();  //clear 檢驗項目
                      date.text="";
                      _selectInspection.clear();
                    });
                  }
                },
                child:Text(
                  '送出',
                  style:TextStyle(color:Color(0xff6c98c6)),
                ),
                style: ElevatedButton.styleFrom(
                  fixedSize:Size(100, 40), backgroundColor: Color(0xfff3f0e2),
                  textStyle: const TextStyle(fontSize: 20),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<bool?> validation(String x)async{  //防呆
    print('類別→'+selectidentify.toString());
    print('主科別→'+selectdepartment.toString());
    RegExp id=RegExp("[A-Z][12]\\d{8}");  //身分證號的正規表達
    bool matchedId = id.hasMatch(ID.text);  //id是否符合
    RegExp InspectionNum=RegExp("[A-Z]\\d{9}"); //檢驗單單號的正規表達
    bool matchedNum = InspectionNum.hasMatch(inspectionNum.text); //看有沒有符合
    if(ID.text.isEmpty||inspectionNum.text.isEmpty) { //身分證號和單號都是空白的
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('欄位不能是空白'),
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
    else if(matchedId==false){  //id格式不符合
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('身分證格式錯誤'),
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
    else if(matchedNum==false){ //檢驗單單號格式不符合
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('檢驗單格式錯誤'),
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
    else if(selectidentify=='-1'){  //沒選擇類別
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('類別不能是空白'),
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
    else if(date.text.isEmpty){ //沒選擇開單日期
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('請選擇開單日期'),
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
    else if(selectdepartment=='-1'){  //沒選主科別
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('主科別不能是空白'),
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

    else if(selectedValue.toString()=="null"){  //沒選擇科別
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('請選擇科別'),
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
    else if(selectedValue2.toString()=="null"){ //沒選擇醫生
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('請選擇醫生'),
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
    else if(L.isEmpty){ //若檢驗項目空白
      haserror=true;
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('錯誤'),
              content: Text('檢驗項目不能是空白'),
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
      haserror=false;
    }
  }

  Future<List> getData(String data) async {
    print("已選類別!");
    print("選擇的類別:"+data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await identifyName(data)); //傳送data等待response
      jsonResponse=convert.jsonDecode(response!.body);  //傳回來的decode
      if (response.statusCode == 200) { //如果回傳狀態碼200
        print(jsonResponse['status']);  //狀態碼
        // print(jsonResponse['checkItemList']);
        // print(jsonResponse['errorMessage']);
        // count=jsonResponse['checkItemList'].length;  //回傳有幾筆資料
        // print(count);
        //print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['checkItemList']);
        print("err");
      }
      loading = false;
      notifyListeners();
    }
    catch(e)
    {
      print("err:"+e.toString());

    }
    setState(() {});
    return jsonResponse['checkItemList']; //回傳回去
  }
  viewDepartment(){
    return  Column(
      children: [
        Row(
          children: [
            Text("科別:",style:TextStyle(fontSize:16),),
            DropdownButton2(
              items:_alldepartment.map((a) =>DropdownMenuItem<String>(
                value:a.departmentName,
                child: Text(
                  a.departmentNum,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),)).toList(),
              value: selectedValue,
              onChanged:(value) {
                selectedValue = value.toString();
                _doctors.clear();
                _alldoctor.clear();
                DocList=getDoctor(selectedValue.toString());  //傳送科別
                DocList.then((value)
                {
                  for(int k=0;k<value.length;k++){
                    _alldoctor.add(alldoctor(value[k]['doctorNum'].toString(),"["+value[k]['doctorNum'].toString()+"]"+value[k]['doctorName'].toString()));
                  }
                });
                setState(() {
                  selectedValue = value.toString();
                  print("選擇的科別:"+selectedValue.toString()); //印出選擇的科編號
                  selectedValue2=null;
                });
              },
              buttonHeight: 30,
              itemHeight: 40,
              dropdownMaxHeight: 150,
              buttonWidth: 300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ],
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        Row(
          children: [
            Text("醫生:",style:TextStyle(fontSize:16),),
            DropdownButton2(  //醫生下拉選單
              items:_alldoctor.map((a) =>DropdownMenuItem<String>(
                value:a.doctorName,
                child: Text(
                  a.doctorNum,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),)).toList(),
              value: selectedValue2,
              onChanged:(value) {
                setState(() {
                  selectedValue2 = value.toString();
                  print("醫生編號:"+selectedValue2.toString()); //印出選擇的醫生編號
                });
              },
              buttonHeight: 50,
              itemHeight: 40,
              dropdownMaxHeight: 150,
              buttonWidth: 300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ],
        )
      ],
    );
  }
  Future<List> getDoctor(String data) async {       //取得醫生
    count=0;
    print("getDoctor");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await doctor1(data));  //等待response(醫生)
      jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['doctorList']);
        count=jsonResponse['doctorList'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['doctorList']);
        print("err");
      }
      loading = false;
      notifyListeners();
    }
    catch(e)
    {
      print("err:"+e.toString());
    }
    setState(() {});

    return jsonResponse['doctorList'];
  }
  Future<List> getDepartment(String data) async { //取得科別
    count=0;
    print("get科別");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await department1(data)); //等待response
      jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['departmentList']);
        count=jsonResponse['departmentList'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['departmentList']);
        print("err");
      }
      loading = false;
      notifyListeners();
    }
    catch(e)
    {
      print("err:"+e.toString());
    }
    setState(() {});

    return jsonResponse['departmentList'];
  }
}