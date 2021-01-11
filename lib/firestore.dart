import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

final FirebaseAuth _auth = FirebaseAuth.instance;

Map<String, dynamic> index;

class Post {
  String id;
  String name;
  String descript;
  String tel;
  String add;
  String region;
  String town;
  String picture1;
  String website;
  String ticketinfo;
  String keyword;
  int classType1;
  int classType2;
  String classTypeText1;
  int like;
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

  Post(DocumentSnapshot snapshot) {
    id = snapshot.id;
    Map<String, dynamic> data = snapshot.data();
    name = data['Name'];
    descript = data['Description'];
    tel = data['Tel'];
    add = data['Add'];
    region = data['Region'];
    town = data['Town'];
    picture1 = data['Picture1'];
    website = data['Website'];
    ticketinfo = data['Ticketinfo'];
    keyword = data['Keyword'];
    classType1 = int.tryParse(data['Class1']);
    like = data.containsKey("like") ? data["like"] : 0;

    if (ticketinfo == '' || ticketinfo == null) {
      ticketinfo = '無票價資訊';
    }

    if (website == '' || website == null) {
      website = '無網站連結';
    }

    if (picture1 == '') {
      picture1 =
          'https://www.energy-bagua.com/topic/wp-content/uploads/sites/8/2020/10/no-image.png';
    }

    if (classType1 == null || classType1 > 18) {
      classType1 = 18;
    }

    if (region == null || town == null) {
      region = "外島";
      town = "";
    }

    classTypeText1 = classList[classType1];
  }
  static MyStream getStream() {
    return MyStream(
      FirebaseFirestore.instance.collection("post").orderBy("Region").limit(5),
    );
  }

  static Future<List<DocumentSnapshot>> getLike() async {
    if(profile == null) await Profile.getProfile();
    CollectionReference colRef = FirebaseFirestore.instance.collection("post");
    List<DocumentSnapshot> result= [];
    for(String id in profile.likes.toList()) {
      result.add(await colRef.doc(id).get());
    }
    return result;
  }

  static Future<List<DocumentSnapshot>> search(String search) async {
    if(index == null) {
      index = jsonDecode(utf8.decode((await http.get("https://firebasestorage.googleapis.com/v0/b/taiwangogo-75be3.appspot.com/o/index.json?alt=media&token=a65e7498-5ab9-46c7-b976-0e4ad48a69c9")).bodyBytes));
    }

    CollectionReference colRef = FirebaseFirestore.instance.collection("post");

    List<DocumentSnapshot> result= [];
    for(String id in index.keys) {
      if((index[id]["Name"] != null && index[id]["Name"].indexOf(search) != -1) || (index[id]["Region"] != null && index[id]["Region"].indexOf(search) != -1)) {
        result.add(await colRef.doc(id).get());
        if(result.length >= 10) break;
      }
    }
    return result;
  }
}

class MyStream {
  Query query;
  List<QueryDocumentSnapshot> documents = [];
  int start = 0;
  MyStream(this.query);
  Future<List<QueryDocumentSnapshot>> getData() async {
    List<QueryDocumentSnapshot> buffer;
    if (documents.length != 0)
      buffer =
          (await query.startAfterDocument(documents.last).get()).docs.toList();
    else
      buffer = (await query.get()).docs.toList();
    documents.addAll(buffer);
    return buffer;
  }

  void refresh() {
    documents = [];
  }
}

Profile profile;

class Profile {
  final DocumentReference docRef;
  final String displayName;
  final String photoURL;
  Set likes;
  Profile(this.docRef, this.displayName, this.photoURL, this.likes) : super();
  static Future<Profile> getProfile() async {
    if (profile != null) {
      return profile;
    }
    User currentUser = _auth.currentUser;
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("profile").doc(currentUser.uid);
    Map<String, dynamic> data = (await docRef.get()).data();
    if (data == null) {
      data = {
        "displayName": currentUser.displayName,
        "photoURL": currentUser.photoURL,
        "likes": []
      };
      docRef.set(data);
    }
    profile = Profile(
        docRef, data["displayName"], data["photoURL"], data["likes"].toSet());
    return profile;
  }

  void like(String postId, int count) {
    likes.add(postId);
    docRef.update({"likes": likes.toList()});
    FirebaseFirestore.instance
        .collection("post")
        .doc(postId)
        .update({"like": count});
  }

  void dislike(String postId, int count) {
    likes.remove(postId);
    docRef.update({"likes": likes.toList()});
    FirebaseFirestore.instance
        .collection("post")
        .doc(postId)
        .update({"like": count});
  }
}

// class LikeList {
//   Set<String> likes;

//   Future<Set<String>> getList() async {
//   }

//   Future<Set<String>> reflush() async {
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection("profile").doc(_auth.currentUser.uid).get();
//     likes = Set(snapshot.data()["likes"]);
//     return likes;
//   }
// }
