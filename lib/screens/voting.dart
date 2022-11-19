import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:myapp/firebase/post.dart';
import 'package:myapp/firebase/userCheck.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key});

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final currentUseruid = authManage().getUser()!.uid;
  final String postId = '';
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget buildPost(Post _post) {
    // isLiked = handleLikePost(_post);

    return Container(
        width: 600,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black), color: Colors.blue[200]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 400,
              height: 300,
              color: Colors.blue[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 200,
                      // height: 200,
                      child: Image.network(
                        '${_post.url}',
                        fit: BoxFit.fill,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '이름 : ${_post.name}',
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '설명 : ${_post.description}',
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '좋아요',
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      LikeButton(
                        likeCount: _post.likecount,
                        // _post.likecount,
                        // isLiked: isLiked,
                        // 여기 고정하면 계속 그 상태로 유지됨

                        onTap: (isLiked) async {
                          // handleLikePost(_post);
                          this.isLiked = !isLiked;
                          this.isLiked
                              ? UpLikeCount(_post)
                              : DownLikeCount(_post);
                          print('heyhehyeyhyeheyheyheyehyeyh');
                          // print(_post.liked!);
                          return !isLiked;
                        },
                        // 하지만 여기서 변경하면 변경됨
                        // onTap: (isLiked) async {
                        //   print('likes');
                        // },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // int likedCounter(Post post) {
  //   int tmp = post.liked!.keys.toList().length;

  //   return tmp;
  // }

  // bool handleLikePost() {
  //   final read = FirebaseStorage.instance.collections()
  //   if (read.liked!.containsKey(currentUseruid)) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  Future UpLikeCount(Post post) async {
    final docPost = FirebaseFirestore.instance
        .collection('post')
        .doc('${post.name}_${post.email}');

    // final json = post.toJson();
    setState(() {
      docPost.update({'liked.${currentUseruid}': true});
      // docPost.update({'likecount': post.liked!.keys.toList().length});
      docPost.update({'likecount': (post.likecount!.toInt() + 1)});
    });

    print('like');
  }

  Future DownLikeCount(Post post) async {
    final docPost = FirebaseFirestore.instance
        .collection('post')
        .doc('${post.name}_${post.email}');

    // final json = post.toJson();
    setState(() {
      docPost.update({'liked.${currentUseruid}': FieldValue.delete()});
    });
    docPost.update({'likecount': (post.likecount!.toInt() - 1)});
    print('dislike');
  }

  Stream<List<Post>> readPost() => FirebaseFirestore.instance
      .collection('post')
      // .orderBy('likecount', descending: true)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList());
}
