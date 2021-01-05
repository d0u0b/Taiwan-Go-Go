import 'dart:math';

class View {
  String Name;
  String Descript;
  String Tel;
  String Add;
  String Region;
  String Town;
  String Picture1;
  String Website;
  String Ticketinfo;
  String Keyword;
  int ClassType1;
  int ClassType2;
  String ClassTypeText1;
  int Zipcode;
  List classList = [
    "",
    "文化",
    "生態",
    "古蹟",
    "廟宇",
    "藝術",
    "小吃、特產",
    "國家公園",
    "國家風景區",
    "休閒農業",
    "溫泉",
    "自然風景",
    "遊憩",
    "體育健身",
    "觀光工廠",
    "都會公園",
    "森林、遊樂區",
    "林場",
    "其他"
  ];

  View({
    this.Name,
    this.Descript,
    this.Tel,
    this.Add,
    this.Region,
    this.Town,
    this.Picture1,
    this.Website,
    this.Ticketinfo,
    this.Keyword,
    this.ClassTypeText1,
    this.Zipcode,
  });

  View.fromJson(Map<String, dynamic> json) {
    Name = json['Name'];
    Descript = json['Description'];
    Tel = json['Tel'];
    Add = json['Add'];
    Region = json['Region'];
    Town = json['Town'];
    Picture1 = json['Picture1'];
    Website = json['Website1'];
    Ticketinfo = json['Ticketinfo'];
    Keyword = json['Keyword'];
    ClassType1 = int.tryParse(json['Class1']);
    Zipcode = int.tryParse(json['Zipcode']);
    // ClassType2 = int.tryParse(json['Class2']);

    if (ClassType1 == null || ClassType1 > 18) {
      ClassType1 = 18;
    }

    if (Region == null || Town == null) {
      Region = "外島";
      Town = "";
    }

    ClassTypeText1 = classList[ClassType1];
  }
}
