class LoginModel {
  final bool status;
  final String? message;
  final UserData? data;

  LoginModel(
    this.status,
    this.message,
    this.data,
  );
  //named constructor
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      json['status'],
      json['message'],
      json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String image;
  final int? points;
  final int credit;
  final String token;

  UserData(
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.points,
    this.credit,
    this.token,
  );
  //named constructor
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['id'],
      json['name'],
      json['email'],
      json['phone'],
      json['image'],
      json['points'],
      json['credit'],
      json['token'],
    );
  }
}
