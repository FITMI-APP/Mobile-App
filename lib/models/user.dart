
class MyUser {
  final String? uid;
  final String fullName;
  final String email;
  final String phone;
  final String password;

  MyUser({
    this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  toJson() {
    return {
      "FullName": fullName,
      "Email": email,
      "Phone": phone,
      "Password": password,
    };
  }

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
    fullName: json['FullName'] as String,
    email: json['Email'] as String,
    phone: json['Phone'] as String,
    password: json['Password'] as String,
  );

  MyUser copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? password,
  }) {
    return MyUser(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}
