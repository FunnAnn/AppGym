class Auth {
  String? fullName;
  String? email;
  String? password;
  int? gender;
  String? dateOfBirth;
  String? phoneNumber;

  Auth(
      {this.fullName,
      this.email,
      this.password,
      this.gender,
      this.dateOfBirth,
      this.phoneNumber});

  Auth.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}