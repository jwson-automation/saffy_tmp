class Post {
  String? name;
  String? description;
  String? url;
  int? likecount;

  Post({this.name, this.description, this.url, this.likecount});

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'url': url,
        'likecount': likecount
      };

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      name: json['name'] == null ? '' : json['name'] as String,
      description:
          json['description'] == null ? '' : json['description'] as String,
      url: json['url'] == null ? '' : json['url'] as String,
      likecount: json['likecount'] == null ? 0 : json['likecount'] as int,
    );
  }
}
