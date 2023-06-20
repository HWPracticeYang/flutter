class inspection1{      //檢驗單的model
  String userId;        //身分證號
  String inspectionNum; //檢驗單單號
  String identifyName;  //類別名稱
  String billingDate;   //開單日期
  String doctorNum;     //醫生編號
  List checkItemNumList;  //檢驗項目編號

  inspection1({
    required this.userId,
    required this.inspectionNum,
    required this.identifyName,
    required this.billingDate,
    required this.doctorNum,
    required this.checkItemNumList,
  });

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data=<String, dynamic>{};
    data['userId']=userId;
    data['inspectionNum']=inspectionNum;
    data['identifyName']=identifyName;
    data['billingDate']=billingDate;
    data['doctorNum']=doctorNum;
    data['checkItemNumList']=checkItemNumList;
    print("Json");
    print(data['checkItemNumList']);
    return data;
  }
}