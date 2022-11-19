// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:myapp/firebase/post.dart';
// import 'package:myapp/firebase/userCheck.dart';
// import 'package:path/path.dart';

// class UploadPage extends StatefulWidget {
//   const UploadPage({super.key});

//   @override
//   State<UploadPage> createState() => _UploadPageState();
// }

// class _UploadPageState extends State<UploadPage> {
//   PlatformFile? pickedFile;
//   UploadTask? uploadTask;
//   final charactercontroller = TextEditingController();
//   final descriptioncontroller = TextEditingController();
//   // File? _pickedImage;
//   // Uint8List webImage = Uint8List(8);
//   File? file;

//   @override
//   Widget build(BuildContext context) {
//     final fileName = file != null ? basename(file!.path) : 'no image';

//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.black)),
//               child: Center(child: Text("Image"))),
//           Text(
//             fileName,
//             style: TextStyle(fontSize: 10),
//           ),
//           Text(
//             "현재 버전에서는 모바일 환경에서만 사진 업로드가 가능합니다!",
//             style: TextStyle(fontSize: 10),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//             onPressed: () {
//               selectFile();
//             },
//             child: Text("사진 업로드"),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Container(
//             width: 300,
//             child: TextField(
//               controller: charactercontroller,
//               decoration: InputDecoration(
//                   hintText: "이름",
//                   hintStyle: TextStyle(color: Colors.blue),
//                   contentPadding: EdgeInsets.all(10),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                       borderSide: BorderSide(color: Colors.blue, width: 2.0))),
//             ),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Container(
//             width: 400,
//             child: TextField(
//               controller: descriptioncontroller,
//               decoration: InputDecoration(
//                   hintText: "설명",
//                   hintStyle: TextStyle(color: Colors.blue),
//                   contentPadding: EdgeInsets.all(10),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(1.0)),
//                       borderSide: BorderSide(color: Colors.blue, width: 2.0))),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//             child: Text("등록하기"),
//             onPressed: () {
//               final url = uploadFile();
//               final post = Post(
//                 url: '${url}',
//                 email: '${authManage().getUser()!.email}',
//                 name: charactercontroller.text,
//                 description: descriptioncontroller.text,
//                 timestamp: Timestamp.now(),
//               );
//               UploadPost(post);
//             },
//           ),
//           buildProgress(),
//         ],
//       ),
//     );
//   }

//   Future UploadPost(Post post) async {
//     final docPost = FirebaseFirestore.instance.collection('post').doc();

//     post.id = docPost.id;
//     final json = post.toJson();
//     await docPost.set(json);
//   }

//   Future<void> selectFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);

//     if (result == null) return;
//     final path = result.files.single.path!;

//     setState(() {
//       file = File(path);
//     });

//     // if (!kIsWeb) {
//     //   final ImagePicker _picker = ImagePicker();
//     //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     //   if (image != null) {
//     //     var selected = File(image.path);

//     //     setState(() {
//     //       _pickedImage = selected;
//     //     });
//     //   } else {
//     //     print('No Image has been picked');
//     //   }
//     // } else if (kIsWeb) {
//     //   final ImagePicker _picker = ImagePicker();
//     //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     //   if (image != null) {
//     //     var f = await image.readAsBytes();
//     //     setState(() {
//     //       webImage = f;
//     //       _pickedImage = File('a');
//     //     });
//     //   } else {
//     //     print('No Image has been picked');
//     //   }
//     // } else {
//     //   print('Something wrong; sorry');
//     // }
//   }

//   Future<String> uploadFile() async {
//     final path = 'files/${pickedFile!.name}';
//     final file = File(pickedFile!.path!);
//     // final destination = 'files/$fileName';
//     // FirebaseApi.uploadFiles(destination, file!);

//     final ref = FirebaseStorage.instance.ref().child(path);

//     setState(() {
//       uploadTask = ref.putFile(file);
//     });

//     final snapshot = await uploadTask!.whenComplete(() {});
//     final urlDownload = await snapshot.ref.getDownloadURL();
//     final url = urlDownload.toString();

//     print('Download Link : $urlDownload');

//     setState(() {
//       uploadTask = null;
//     });
//     return url;
//   }

//   Widget buildProgress() => StreamBuilder<TaskSnapshot>(
//         stream: uploadTask?.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final data = snapshot.data!;
//             double progress = data.bytesTransferred / data.totalBytes;

//             return SizedBox(
//               height: 50,
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.grey,
//                     color: Colors.green,
//                   ),
//                   Center(
//                     child: Text(
//                       '${(100 * progress).roundToDouble()}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           } else {
//             return const SizedBox(
//               height: 50,
//             );
//           }
//         },
//       );
// }

// // class FirebaseApi {
// //   static UploadTask? uploadFiles(String destination, File file) {
// //     try {
// //       final ref = FirebaseStorage.instance.ref(destination);

// //       return ref.putFile(file);
// //     } on FirebaseException catch (e) {
// //       return null;
// //     }
// //   }
// // }
