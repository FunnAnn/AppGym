class Schedule {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Schedule({this.data, this.message, this.statusCode, this.date});

  Schedule.fromJson(Map<String, dynamic> json) {
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
  int? scheduleId;
  int? customerId;
  int? coachId;
  String? title;
  String? startDate;
  String? endDate;
  String? description;
  String? color;
  Customers? customers;

  Data(
      {this.scheduleId,
      this.customerId,
      this.coachId,
      this.title,
      this.startDate,
      this.endDate,
      this.description,
      this.color,
      this.customers});

  Data.fromJson(Map<String, dynamic> json) {
    scheduleId = json['schedule_id'];
    customerId = json['customer_id'];
    coachId = json['coach_id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    description = json['description'];
    color = json['color'];
    customers = json['customers'] != null
        ? new Customers.fromJson(json['customers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedule_id'] = this.scheduleId;
    data['customer_id'] = this.customerId;
    data['coach_id'] = this.coachId;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['description'] = this.description;
    data['color'] = this.color;
    if (this.customers != null) {
      data['customers'] = this.customers!.toJson();
    }
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

class Users {
  int? userId;
  String? fullName;
  String? avatar;

  Users({this.userId, this.fullName, this.avatar});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['avatar'] = this.avatar;
    return data;
  }
}
