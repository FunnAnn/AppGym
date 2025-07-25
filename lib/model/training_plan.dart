class TrainingPlan {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  TrainingPlan({this.data, this.message, this.statusCode, this.date});

  TrainingPlan.fromJson(Map<String, dynamic> json) {
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
  int? planId;
  int? coachId;
  int? customerId;
  String? description;
  String? dietPlan;
  Coaches? coaches;
  Customers? customers;

  Data(
      {this.planId,
      this.coachId,
      this.customerId,
      this.description,
      this.dietPlan,
      this.coaches,
      this.customers});

  Data.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    coachId = json['coach_id'];
    customerId = json['customer_id'];
    description = json['description'];
    dietPlan = json['diet_plan'];
    coaches =
        json['coaches'] != null ? new Coaches.fromJson(json['coaches']) : null;
    customers = json['customers'] != null
        ? new Customers.fromJson(json['customers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['coach_id'] = this.coachId;
    data['customer_id'] = this.customerId;
    data['description'] = this.description;
    data['diet_plan'] = this.dietPlan;
    if (this.coaches != null) {
      data['coaches'] = this.coaches!.toJson();
    }
    if (this.customers != null) {
      data['customers'] = this.customers!.toJson();
    }
    return data;
  }
}

class Coaches {
  int? userId;
  Null? specialization;
  Null? bio;
  Null? ratingAvg;
  Users? users;

  Coaches(
      {this.userId, this.specialization, this.bio, this.ratingAvg, this.users});

  Coaches.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    specialization = json['specialization'];
    bio = json['bio'];
    ratingAvg = json['rating_avg'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['specialization'] = this.specialization;
    data['bio'] = this.bio;
    data['rating_avg'] = this.ratingAvg;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

class Users {
  int? userId;
  String? fullName;
  String? email;
  String? dateOfBirth;
  String? phoneNumber;
  String? avatar;

  Users(
      {this.userId,
      this.fullName,
      this.email,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatar});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Customers {
  int? userId;
  Null? healthInfo;
  Null? goals;
  Users? users;

  Customers({this.userId, this.healthInfo, this.goals, this.users});

  Customers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    healthInfo = json['health_info'];
    goals = json['goals'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['health_info'] = this.healthInfo;
    data['goals'] = this.goals;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}
