import 'package:cloud_firestore/cloud_firestore.dart';

class Liked {
  String id;

  Liked({
    this.id = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
      };

  factory Liked.fromJson(Map<String, dynamic> json) {
    return Liked();
  }
}
