import 'dart:convert';
import 'dart:html';
import 'package:provider/provider.dart';
import 'package:inspection/service/doctor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert ;
import 'dart:async';
import 'package:inspection/service/identifyName.dart';
import 'package:inspection/get/getCheckItem.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:inspection/service/department.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:inspection/model/inspection.dart';
import 'package:inspection/postData.dart';

TextEditingController inspectionNum = TextEditingController();
TextEditingController ID = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController doctor = TextEditingController();

enum identify{SONO,CT,MRI,BMD}
enum department{Medicine,surgery, specialist}


String? selectedValue;
String? selectedValue2;

identify?_identify;
department?_department;
var selectdepartment;
var selectidentify;
List L=[];
late Future<List<dynamic>> list;
late Future<List<dynamic>> Dlist;
late Future<List<dynamic>> DocList;

class inspection{ //檢驗單類別
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
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Send>(
          create: (context) => Send(),
        ),
      ],
      child:Web(),
    )
  );
}

class Web extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        backgroundColor:Color(0xfff7d78c),
        appBar: AppBar(
          title:Image.asset('lib/assets/images/logo1.png',width:200,),
          backgroundColor:Color(0xffA6D3F2),
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
class MyForm extends StatelessWidget {
  const MyForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:<Widget> [
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        TextField( //輸入ID
          controller: ID,
          decoration: const InputDecoration(
            labelText:'身分證號',
          ),
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        TextField(  //輸入檢驗單單號
          controller: inspectionNum,
          decoration: const InputDecoration(
            labelText:'檢驗單單號',
            // border: OutlineInputBorder(),
            //hintText: '',
          ),
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        Column(             //選檢驗類別
          children:const [
            Center(
              child: chooseIdentify(),
            ),
          ],
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        chooseDate(),      //選擇開單日期
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        Column(             //選主科別
          children:const [
            Center(
              child: chooseDepartment(),
            ),
          ],
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:5),
        ),
        btn(),//送出按鈕

      ],
    );
  }
}
class chooseIdentify extends StatefulWidget{
  const chooseIdentify({key});
  @override
  State<StatefulWidget> createState(){
    return _chooseIdentify();
  }
}

class _chooseIdentify extends State<chooseIdentify> with ChangeNotifier{
  List<MultiSelectItem<inspection>> _items = [];
  final List<inspection> _inspection = [];  //檢驗單List
  List<inspection> _selectInspection = [];
  List<MultiSelectItem<inspection>> empty = [];
  bool loading = false;
  bool isBack = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children:<Widget> [
            Text("類別:",style: TextStyle(fontSize:16)),
            Radio<identify>(
              value:identify.SONO,
              activeColor:Color(0xffAFC3A8),
              groupValue: _identify,
              onChanged:(identify? value){
                _items.clear();
                _inspection.clear();
                selectidentify="SONO";
                list=getData(selectidentify);
                list.then((value){
                  for(int i = 0; i < value.length; i++){
                    //print(value.length);
                    //print(value[i]['checkItemNum']);
                    _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                  }
                  _items = _inspection.map((inspection e) => MultiSelectItem<inspection>(e, e.name)).toList();
                });
                setState(() {
                  _identify=value;
                });
              },
            ),
            Text("SONO",style: TextStyle(fontSize:16)),
            Radio<identify>(
              value: identify.CT,
              activeColor:Color(0xffAFC3A8),
              groupValue: _identify,
              onChanged:(identify? value){
                _items.clear();
                _inspection.clear();
                selectidentify="CT";
                list=getData(selectidentify);
                print(list);
                list.then((value){
                  for(int i = 0; i < value.length; i++){
                    // print(value.length);
                    // print(value[i]['checkItemNum']);
                    _inspection.add(inspection(value[i]['checkItemNum'].toString(),"["+value[i]['checkItemNum'].toString()+"] "+value[i]['checkItemName'].toString(),));
                  }
                  _items = _inspection.map((e) => MultiSelectItem<inspection>(e, e.name)).toList();
                });
                setState(() {
                  _identify=value;
                });
              },
            ),
            Text("CT",style: TextStyle(fontSize:16)),
            Radio<identify>(
              value: identify.MRI,
              activeColor:Color(0xffAFC3A8),
              groupValue: _identify,
              onChanged:(identify? value){
                _items.clear();
                _inspection.clear();
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
                  _identify=value;
                });
              },
            ),
            Text("MRI",style: TextStyle(fontSize:16)),
            Radio<identify>(
              value: identify.BMD,
              activeColor:Color(0xffAFC3A8),
              groupValue: _identify,
              onChanged:(identify? value)  {
                _items.clear();
                _inspection.clear();

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

          ],
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        MultiSelectDialogField<inspection>(
          searchable: true,
          items:_items,
         // title: Text("檢驗項目",style:TextStyle(Color(0xff0000)) ),
          listType: MultiSelectListType.LIST,
          backgroundColor:Color(0xff467897),
          selectedColor:Color(0xffe7cd79),

          onConfirm: (values) {

            print("value");
            print(values);
            _selectInspection = values;
            // print("CC"+_selectInspection.toString());
            L.clear();
            print("List");
            print(L);
            _selectInspection.forEach((element) {
              L.add(element.identifyNum);
              // print(element.identifyNum);
            });
            // print("LLL"+L.toString());
          },
        ),
      ],
    );
  }

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
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['data']);
        count=jsonResponse['data'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
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
    setState(() {});
    return jsonResponse['data'];
  }
}
class chooseDate extends StatefulWidget{  //開單日期
  @override
  State<StatefulWidget> createState() {
    return _chooseDate();
  }
}
class _chooseDate extends State<chooseDate>{
  late DateTime selectDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
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
                firstDate: DateTime(2022,01),
                lastDate: DateTime.now(),
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
    );
  }
}
class btn extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _btn();
  }
}
class _btn extends State<btn> {   //送出
  @override
  Widget build(BuildContext context) {
    String str="";
    return Row(
      children: [
        Padding(
          padding:EdgeInsets.only(left:145,top:80),
          child:ElevatedButton(
            onPressed:(){

             setState(() {
               inspection1 Inspection=inspection1(userId:ID.text, inspectionNum: inspectionNum.text, identifyName: selectidentify.toString(), billingDate: date.text.toString(), doctorNum: selectedValue2.toString(), checkItemNumList:L);
               var provider = Provider.of<Send>(context, listen: false);
               provider.postData(Inspection);
               ID.text="";
               inspectionNum.text="";
               date.text="";
               selectedValue2="";
               L.clear();
             });

            },
            child:Text(
              '送出',
              style:TextStyle(color:HexColor('#ffffff')),
            ),
            style: ElevatedButton.styleFrom(
              fixedSize:Size(100, 40),
              primary:HexColor('#97D4E7'),
              textStyle: const TextStyle(fontSize: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class chooseDepartment extends StatefulWidget{
  const chooseDepartment({key});
  @override
  State<StatefulWidget> createState(){
    return _chooseDepartment();
  }
}
class _chooseDepartment extends State<chooseDepartment> with ChangeNotifier {   //選主科別
  List<MultiSelectItem<alldepartment>> _items = [];
  final List<alldepartment> _alldepartment = [];
  List<MultiSelectItem<alldoctor>> _doctors = [];
  final List<alldoctor> _alldoctor = [];
  bool loading = false;
  bool isBack = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children:<Widget> [
            Text("主科別:",style: TextStyle(fontSize:16)),
            Radio<department>(
              value: department.Medicine,
              activeColor:Color(0xffAFC3A8),
              groupValue: _department,
              onChanged:(department? value){
                _items.clear();
                _alldepartment.clear();
                selectidentify="內科系";
                Dlist=getDepartment(selectidentify);
                Dlist.then((value){
                  for(int j=0;j<value.length;j++){
                   _alldepartment.add(alldepartment(value[j]['departmentNum'].toString(),"["+value[j]['departmentNum'].toString()+"] "+value[j]['departmentName'].toString(),));
                  }
                  print(_alldepartment);
                });
                setState(() {
                  _department=value;
                  selectedValue = null;
                });
              },
            ),
            Text("內科別",style: TextStyle(fontSize:16)),
            Radio<department>(
              value: department.surgery,
              activeColor:Color(0xffAFC3A8),
              groupValue: _department,
              onChanged:(department? value){
                _items.clear();
                _alldepartment.clear();
                selectidentify="外科系";
                Dlist=getDepartment(selectidentify);
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
                });
              },
            ),
            Text("外科別",style: TextStyle(fontSize:16)),
            Radio<department>(
              value: department.specialist,
              activeColor:Color(0xffAFC3A8),
              groupValue: _department,
              onChanged:(department? value){
                _items.clear();
                _alldepartment.clear();
                selectidentify="各專科";
                Dlist=getDepartment(selectidentify);
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
                });
              },
            ),
            Text("各專科",style: TextStyle(fontSize:16)),
          ],
        ),
        Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        viewDepartment(),
        //viewDoctor(),
      ],
    );
  }
  viewDepartment(){
    return  Column(
      children: [
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
             DocList=getDoctor(selectedValue.toString());
             DocList.then((value)
             {
               for(int k=0;k<value.length;k++){
                 _alldoctor.add(alldoctor(value[k]['doctorNum'].toString(),"["+value[k]['doctorNum'].toString()+"]"+value[k]['doctorName'].toString()));
               }
             });
            setState(() {
            selectedValue = value.toString();
            print("科別:"+selectedValue.toString()); //印出選擇的科編號
              selectedValue2=null;
            });
          },
            buttonHeight: 30,
            itemHeight: 40,
            dropdownMaxHeight: 150,
            buttonWidth: 300,
            itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        DropdownButton2(  //醫生
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
    );
  }

  Future<List> getDepartment(String data) async { //取得科別
    count=0;
    print("postData");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await department1(data)); //等待response
       jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['data']);
        count=jsonResponse['data'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
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
    setState(() {});

    return jsonResponse['data'];
  }

  Future<List> getDoctor(String data) async {       //取得醫生
    count=0;
    print("getData");
    print(data);
    notifyListeners();
    var jsonResponse;
    try
    {
      http.Response ?response = (await doctor1(data));  //等待response(醫生)
      jsonResponse = json.decode(utf8.decode(response!.bodyBytes));
      if (response.statusCode == 200) {
        print(jsonResponse['status']);  //狀態碼
        print(jsonResponse['data']);
        count=jsonResponse['data'].length;  //回傳有幾筆資料
        print(count);
        print("200");
        isBack = true;
      }
      else
      {
        print(jsonResponse['status']);  //狀態碼
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
    setState(() {});

    return jsonResponse['data'];
  }
}