class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    return Login(
      code: obj['code'] is String ? int.tryParse(obj['code']) : obj['code'],
      status: obj['status'],
      token: obj['data']?['token'] ?? obj['token'],
      userID: obj['data']?['user']?['id'] is String
          ? int.tryParse(obj['data']?['user']?['id'])
          : obj['data']?['user']?['id'],
      userEmail: obj['data']?['user']?['email'] ?? obj['user']?['email'],
    );
  }
}