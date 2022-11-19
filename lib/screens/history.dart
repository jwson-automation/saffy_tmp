import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase/userdata.dart';

import '../firebase/userCheck.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final historyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "다같이 싸피 합격합시다? - 9기 블루베리",
            style: TextStyle(color: Colors.blue, fontSize: 30),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              width: 300,
              child: TextField(
                controller: historyController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "원하는 글을 적어주세요"),
              )),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text("기록 남기기"),
            onPressed: () {
              final history = History(
                  email: '${authManage().getUser()!.email}',
                  text: historyController.text,
                  timestamp: Timestamp.now());

              print(authManage().getUser()!.email);

              UploadHistory(history);
            },
          ),
          Container(
            child: StreamBuilder<List<History>>(
                stream: readUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _history = snapshot.data!;

                    return ListView(
                      reverse: true,
                      shrinkWrap: true,
                      children: _history.map(buildUser).toList(),
                    );
                  } else {
                    print('wait....');
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget buildUser(History _history) => Container(

          // height: 50,
          child: Center(
        child: Column(
          children: [
            Container(
              width: 700,
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              child: Center(
                child: Text(
                  '${_history.text}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ));

  Stream<List<History>> readUser() => FirebaseFirestore.instance
      .collection('history')
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => History.fromJson(doc.data())).toList());

  Future UploadHistory(History history) async {
    final docUser = FirebaseFirestore.instance.collection('history').doc();

    history.id = docUser.id;
    final json = history.toJson();
    await docUser.set(json);
  }
}

class History {
  String? id;
  String? email;
  final String? text;
  Timestamp? timestamp;

  History({
    this.id = '',
    this.email,
    this.text,
    this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'text': text,
        'timestamp': timestamp,
      };

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
        email: json['email'] == null ? '' : json['email'] as String,
        text: json['text'] == null ? '' : json['text'] as String);
  }
}
