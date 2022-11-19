import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Post {
  String id;
  String? name;
  String? description;
  String? url;
  String? email;
  int? likecount;
  Timestamp? timestamp;
  Map<String, dynamic>? liked;

  Post(
      {this.id = '',
      this.name,
      this.description,
      this.url,
      this.email,
      this.likecount,
      this.timestamp,
      this.liked});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'url': url,
        'email': email,
        'likecount': likecount,
        'timestamp': timestamp,
      };

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'] == null ? '' : json['name'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      url: json['url'] == null ? '' : json['url'] as String,
      email: json['email'] == null ? '' : json['email'] as String,
      likecount: json['likecount'] == null ? 0 : json['likecount'] as int,
    );
  }
}
