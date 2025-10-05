class UserModel {
  String fullName;
  String email;
  String password;
  String phone;
  String role;
  String avatar;

  UserModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
    required this.role,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullName": fullName,
      "email": email,
      "password": password,
      "phone": phone,
      "role": role,
      "avatar": avatar,
    };
  }
}
