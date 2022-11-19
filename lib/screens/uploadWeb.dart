import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:myapp/firebase/post.dart';
import 'package:myapp/firebase/userCheck.dart';

class UploadWebPage extends StatefulWidget {
  const UploadWebPage({super.key});

  @override
  State<UploadWebPage> createState() => _UploadWebPageState();
}

class _UploadWebPageState extends State<UploadWebPage> {
  String imageUrl = '';
  String selecteFile = '';
  XFile? file;
  Uint8List? selectedImageInBytes;
  String uploadState = '';
  final charactercontroller = TextEditingController();
  final descriptioncontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black)),
              child: selecteFile.isEmpty
                  ? Center(child: Text(" No Image "))
                  : Image.memory(selectedImageInBytes!)

              // Image.file(
              //     File(file!.path),
              //     fit: BoxFit.fill,
              //   )
              ),
          Text(
            selecteFile,
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              _selectFile();
            },
            child: Text("사진 선택"),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 150,
            child: TextField(
              controller: charactercontroller,
              decoration: InputDecoration(
                  hintText: "이름",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: 400,
            child: TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                  hintText: "설명",
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding: EdgeInsets.all(10),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(1.0)),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0))),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: Text("등록하기"),
            onPressed: () {
              _uploadFile();
            },
          ),
          SizedBox(height: 10),
          Text(
            uploadState,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> selectFile() async {}

  // Future<String> uploadFile() async {
  // }

  Future UploadPost(Post post) async {
    final docPost = FirebaseFirestore.instance
        .collection('post')
        .doc('${post.name}_${authManage().getUser()!.email}');

    post.id = docPost.id;
    final json = post.toJson();
    await docPost.set(json);
  }

  _uploadFile() async {
    try {
      firebase_storage.UploadTask? uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/')
          .child('${selecteFile}');

      final metadata =
          firebase_storage.SettableMetadata(contentType: 'image/jpeg');

      // uploadTask = ref.putFile(File(file!.path));
      uploadTask = ref.putData(selectedImageInBytes!, metadata);

      await uploadTask.whenComplete(() => null);

      imageUrl = await ref.getDownloadURL();

      print('image Url : ${imageUrl}');

      final post = Post(
        url: imageUrl,
        likecount: 0.toInt(),
        name: charactercontroller.text,
        description: descriptioncontroller.text,
        email: authManage().getUser()!.email,
        timestamp: Timestamp.now(),
      );

      UploadPost(post);

      setState(() {
        uploadState = '업로드 완료!';
      });
    } catch (e) {
      print(e);
    }
  }

  _selectFile() async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();
    if (fileResult != null) {
      setState(() {
        print('i am here');
        selecteFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
      });
    }
    print('no');
  }
}
