class Checkin {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Checkin({this.data, this.message, this.statusCode, this.date});

  Checkin.fromJson(Map<String, dynamic> json) {
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
  int? checkinId;
  int? userId;
  String? checkinTime;
  String? checkoutTime;
  Users? users;

  Data(
      {this.checkinId,
      this.userId,
      this.checkinTime,
      this.checkoutTime,
      this.users});

  Data.fromJson(Map<String, dynamic> json) {
    checkinId = json['checkin_id'];
    userId = json['user_id'];
    checkinTime = json['checkin_time'];
    checkoutTime = json['checkout_time'];
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['checkin_id'] = this.checkinId;
    data['user_id'] = this.userId;
    data['checkin_time'] = this.checkinTime;
    data['checkout_time'] = this.checkoutTime;
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
  String? phoneNumber;
  String? avatar;

  Users(
      {this.userId, this.fullName, this.email, this.phoneNumber, this.avatar});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    return data;
  }
}
