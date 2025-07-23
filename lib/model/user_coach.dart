class UserCoach {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  UserCoach({this.data, this.message, this.statusCode, this.date});

  UserCoach.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    statusCode = json['statusCode'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    data['date'] = this.date;
    return data;
  }
}

class Data {
  int? userId;
  String? fullName;
  String? email;
  String? phoneNumber;
  bool? gender;
  String? dateOfBirth;
  String? avatar;
  List<CoachCustomer>? coachCustomers;

  Data(
      {this.userId,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.gender,
      this.dateOfBirth,
      this.avatar,
      this.coachCustomers});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    avatar = json['avatar'];
    if (json['coach_customers'] != null) {
      coachCustomers = <CoachCustomer>[];
      json['coach_customers'].forEach((v) {
        coachCustomers!.add(CoachCustomer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['avatar'] = this.avatar;
    if (this.coachCustomers != null) {
      data['coach_customers'] = this.coachCustomers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoachCustomer {
  int? customerId;
  int? coachId;

  CoachCustomer({this.customerId, this.coachId});

  CoachCustomer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    coachId = json['coach_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['coach_id'] = this.coachId;
    return data;
  }
}
