class UserFields {
  static const String id = "\$id";
  static const String name = "name";
  static const String email = "email";
  static const String registrationDate = "registration";
  static const String roles = "roles";
  static const String prn = "prn";
}

class User {
  late String id;
  late String email;
  late String? registration;
  late String name;
  late String? prn;

  User(
      {required this.id,
      required this.email,
      required this.registration,
      required this.name,
      required this.prn});

  User.fromJson(Map<String, dynamic> json) {
    id = json[UserFields.id];
    email = json[UserFields.email];
    registration = json[UserFields.registrationDate];
    name = json[UserFields.name];
    prn = json[UserFields.prn];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[UserFields.id] = this.id;
    data[UserFields.email] = this.email;
    data[UserFields.registrationDate] = this.registration;
    data[UserFields.name] = this.name;
    data[UserFields.prn] = this.prn;
    return data;
  }
}
