class inspection1{
  String userId;
  String inspectionNum;
  String identifyName;
  String billingDate;
  String doctorNum;
  List checkItemNumList;

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
    print( data['checkItemNumList']);
    return data;
 }
}