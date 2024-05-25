class User {
  int id;
  String username;
  String email;
  String name;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        name = json['name'];
}