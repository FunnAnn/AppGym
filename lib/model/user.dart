class User {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  User({this.data, this.message, this.statusCode, this.date});

  User.fromJson(Map<String, dynamic> json) {
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
  String? role;
  Null? specialization;
  Null? bio;
  Null? ratingAvg;
  List<CoachCustomers>? coachCustomers;
  Null? healthInfo;
  Null? goals;

  Data(
      {this.userId,
      this.fullName,
      this.email,
      this.phoneNumber,
      this.gender,
      this.dateOfBirth,
      this.avatar,
      this.role,
      this.specialization,
      this.bio,
      this.ratingAvg,
      this.coachCustomers,
      this.healthInfo,
      this.goals});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    avatar = json['avatar'];
    role = json['role'];
    specialization = json['specialization'];
    bio = json['bio'];
    ratingAvg = json['rating_avg'];
    if (json['coach_customers'] != null) {
      coachCustomers = <CoachCustomers>[];
      json['coach_customers'].forEach((v) {
        coachCustomers!.add(new CoachCustomers.fromJson(v));
      });
    }
    healthInfo = json['health_info'];
    goals = json['goals'];
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
    data['role'] = this.role;
    data['specialization'] = this.specialization;
    data['bio'] = this.bio;
    data['rating_avg'] = this.ratingAvg;
    if (this.coachCustomers != null) {
      data['coach_customers'] =
          this.coachCustomers!.map((v) => v.toJson()).toList();
    }
    data['health_info'] = this.healthInfo;
    data['goals'] = this.goals;
    return data;
  }
}

class CoachCustomers {
  int? customerId;
  String? customerFullName;
  String? customerEmail;
  String? customerPhoneNumber;
  bool? customerGender;
  String? customerDateOfBirth;
  String? customerAvatar;
  int? coachId;
  String? coachFullName;
  String? coachEmail;
  String? coachPhoneNumber;
  bool? coachGender;
  String? coachDateOfBirth;
  String? coachAvatar;

  CoachCustomers(
      {this.customerId,
      this.customerFullName,
      this.customerEmail,
      this.customerPhoneNumber,
      this.customerGender,
      this.customerDateOfBirth,
      this.customerAvatar,
      this.coachId,
      this.coachFullName,
      this.coachEmail,
      this.coachPhoneNumber,
      this.coachGender,
      this.coachDateOfBirth,
      this.coachAvatar});

  CoachCustomers.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerFullName = json['customer_full_name'];
    customerEmail = json['customer_email'];
    customerPhoneNumber = json['customer_phone_number'];
    customerGender = json['customer_gender'];
    customerDateOfBirth = json['customer_date_of_birth'];
    customerAvatar = json['customer_avatar'];
    coachId = json['coach_id'];
    coachFullName = json['coach_full_name'];
    coachEmail = json['coach_email'];
    coachPhoneNumber = json['coach_phone_number'];
    coachGender = json['coach_gender'];
    coachDateOfBirth = json['coach_date_of_birth'];
    coachAvatar = json['coach_avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_full_name'] = this.customerFullName;
    data['customer_email'] = this.customerEmail;
    data['customer_phone_number'] = this.customerPhoneNumber;
    data['customer_gender'] = this.customerGender;
    data['customer_date_of_birth'] = this.customerDateOfBirth;
    data['customer_avatar'] = this.customerAvatar;
    data['coach_id'] = this.coachId;
    data['coach_full_name'] = this.coachFullName;
    data['coach_email'] = this.coachEmail;
    data['coach_phone_number'] = this.coachPhoneNumber;
    data['coach_gender'] = this.coachGender;
    data['coach_date_of_birth'] = this.coachDateOfBirth;
    data['coach_avatar'] = this.coachAvatar;
    return data;
  }
}
