class User {
  User({
    required this.username,
    required this.userId,
    required this.email,
    required this.userImageUrl,
  });

  final String username;
  final String userId;
  final String email;
  final String userImageUrl;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      userId: json['userId'],
      email: json['email'],
      userImageUrl: json['image_url'],
    );
  }
}
