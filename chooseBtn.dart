import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:js';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:web/chooseBtn.dart';
import 'package:web/get/getSchedule.dart';
final List<String> identify = [
  'SONO',
  'MRI',
  'CT',
  'BMD',
];
String? selectIdentify='SONO';
late Future<List<dynamic>> ScheduleList =Future.value([]);
late DataTableSource _sourceData;
List <dynamic> list=[];
List<dynamic> jsonList=[];
bool exist=true;

void buttonSchedule() async{  //查看當前時間後的排程
  runApp(
    schedule(),
  );
}

class schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      initialRoute: '/schedule',
      debugShowCheckedModeBanner:false,
      home: Scaffold(
        backgroundColor:const Color(0xfff3f0e2),
        appBar: AppBar(
          title:Image.asset('lib/assets/logo.png',width:200,),
          backgroundColor:const Color(0xff6c98c6),
        ),
        drawer: Drawer(               //側邊選單
          child: ListView(
            padding:EdgeInsets.zero,
            children: [
              ListTile(
                leading:Icon(Icons.add),
                title: Text(
                  '新增檢驗單',
                ),
                onTap: (){
                  Navigator.popAndPushNamed(context,'/');
                },
                hoverColor:Color(0xffDCE1F0),
                selectedColor:Color(0xff7A82AB),
                selected:true,
              ),
              ListTile(
                leading:Icon(Icons.alarm_on_rounded),
                title:Text('顯示排程'),
                onTap:(){
                  list.clear();
                  Navigator.popAndPushNamed(context,'/schedule');
                },
                hoverColor:Color(0xffDCE1F0),
                selectedColor:Color(0xff7A82AB),
                selected:true,
              ),
              ListTile(
                leading:Icon(Icons.ac_unit_outlined),
                title: Text('登出'),
                onTap:(){
                  Navigator.popAndPushNamed(context,'/leave');
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
            width:920,
            child:Container(
              child: scheduleList(),
              margin: EdgeInsets.only(left: 50,top:10,right: 0,bottom:10),
            ),
          ),
        ),
      ),
    );
  }
}
class scheduleList extends StatefulWidget{
  const scheduleList({key});
  @override
  State<StatefulWidget> createState(){
    return _scheduleList();
  }
}

class _scheduleList extends State<scheduleList>{

  void initState(){   //初始
    super.initState();
    selectIdentify="SONO";
    GetData(selectIdentify!);
  }

  @override
  Widget build(BuildContext context){
    return ListView(
      children:<Widget> [
        Row(
          children: [
            Icon(Icons.search),
            const Text('查看已排程檢驗單',
              textAlign:TextAlign.center,
              style:TextStyle(color:Colors.black,fontSize:20),
            ),
            SizedBox(
              width:94,
              height:30,
              child:DropdownButtonHideUnderline(  //下拉選單
                child: DropdownButton2(
                  hint:const Text(
                    '類別',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  items: identify
                      .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
                      .toList(),
                  value:selectIdentify,
                  onChanged: (value) {
                    GetData(value.toString());//傳到GetData
                    setState(() {
                      selectIdentify = value.toString();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding:EdgeInsets.only(bottom:20),
        ),
        Column(
         children: [
           //SizedBox(height:40,),
           FutureBuilder<List<dynamic>>(
             future: DataClass3().getSchedule(ScheduleList.toString()),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 // 如果還在等待資料，顯示載入中的進度指示器
                 return CircularProgressIndicator();
               }
               // 如果有資料，使用 PaginatedDataTable 顯示資料
               final hasData = snapshot.data!;
                 return PaginatedDataTable(
                   dataRowMaxHeight:50,
                   columns:const [
                     DataColumn(label:Text('身分證號')),
                     DataColumn(label:Text('檢驗單單號')),
                     DataColumn(label:Text('檢驗項目編號')),
                     DataColumn(label:Text('檢驗項目名稱')),
                     DataColumn(label:Text('排程時間')),
                   ],
                   source:_sourceData,
                   rowsPerPage: 10,
                   sortAscending:true,
                   sortColumnIndex:1,
                 );
               }
           )
         ],
       ),
      ],
    );
  }

    void GetData(String value) {
    ScheduleList = DataClass3().getSchedule(value.toString()); //傳類別
    print('傳出檢驗類別名稱:' + value.toString());
    ScheduleList.then((value) { //打開Future取值
          list = value;
    });
    setState(() {
      _sourceData = SourceData();
    });
  }
}

class SourceData extends DataTableSource{
  @override
  DataRow? getRow(int index){   //把資料(list)填表變成datatable，一行一行填資料進去
    Map<String, dynamic> row = list[index];
    if (index >= list.length) {
      return null;
    }
      DataRow dr = DataRow.byIndex(
          index:index,
          cells: <DataCell>[
            DataCell(Text(list[index]['userId'].toString())),
            DataCell(Text(list[index]['inspectionNum'].toString())),
            DataCell(
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    row['checkItemList'].length,
                        (index) => Text(row['checkItemList'][index]['checkItemNum'].toString()),
                  ),
                ),
              ),
            ),
            DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      row['checkItemList'].length,
                          (index) => Text(row['checkItemList'][index]['checkItemName'].toString()),
                    ),
                  ),
                )
            ),
            DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      row['checkItemList'].length,
                          (index) => Text(row['checkItemList'][index]['scheduleTime'].toString().substring(0,10)+"  "+row['checkItemList'][index]['scheduleTime'].toString().substring(11,19).toString()),
                    ),
                  ),
                )
            ),
          ]);

      return dr;
  }

  @override //是否行數不確定
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override //有多少行
  // TODO: implement rowCount
  int get rowCount => list.length;


  @override //選中的行數
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

// @override
// DataRow? getRow(int index) {
//   // TODO: implement getRow
//   throw UnimplementedError();
// }
}