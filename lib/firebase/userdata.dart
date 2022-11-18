class User {
  String id;
  final String name;
  final int age;
  final int who;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.who,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'who': who,
      };

  static User fromJson(Map<String, dynamic> json) => User(
      id: json['id'], name: json['name'], age: json['age'], who: json['who']);
}
