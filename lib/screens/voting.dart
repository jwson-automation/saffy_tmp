import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase/post.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<List<Post>>(
                  stream: readPost(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final _post = snapshot.data!;

                      return Column(children: _post.map(buildPost).toList());
                    } else {
                      print('wait....');
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget buildPost(Post _post) => Container(
      width: 500,
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // width: 100,
            // height: 500,
            color: Colors.amber[50],
            child: Column(
              children: [
                Image.network(_post.url.toString()),
                Text(
                  '${_post.name}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${_post.description}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                Text(
                  '좋아요 수 : ${_post.likecount}',
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));

  Stream<List<Post>> readPost() => FirebaseFirestore.instance
      .collection('post')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());

  Future UploadPost(Post post) async {
    final docUser =
        FirebaseFirestore.instance.collection('post').doc('${post.name}');

    // post.id = docUser.id;
    final json = post.toJson();
    await docUser.set(json);
  }
}
