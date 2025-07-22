class Membership {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Membership({this.data, this.message, this.statusCode, this.date});

  Membership.fromJson(Map<String, dynamic> json) {
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
  int? cardId;
  int? customerId;
  int? packageId;
  String? startDate;
  String? endDate;
  String? status;
  Customers? customers;
  Packages? packages;

  Data(
      {this.cardId,
      this.customerId,
      this.packageId,
      this.startDate,
      this.endDate,
      this.status,
      this.customers,
      this.packages});

  Data.fromJson(Map<String, dynamic> json) {
    cardId = json['card_id'];
    customerId = json['customer_id'];
    packageId = json['package_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    customers = json['customers'] != null
        ? new Customers.fromJson(json['customers'])
        : null;
    packages = json['packages'] != null
        ? new Packages.fromJson(json['packages'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_id'] = this.cardId;
    data['customer_id'] = this.customerId;
    data['package_id'] = this.packageId;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    if (this.customers != null) {
      data['customers'] = this.customers!.toJson();
    }
    if (this.packages != null) {
      data['packages'] = this.packages!.toJson();
    }
    return data;
  }
}

class Customers {
  Users? users;

  Customers({this.users});

  Customers.fromJson(Map<String, dynamic> json) {
    users = json['users'] != null ? new Users.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  String? role;

  Users(
      {this.userId,
      this.fullName,
      this.email,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatar,
      this.role});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    data['role'] = this.role;
    return data;
  }
}

class Packages {
  int? packageId;
  String? packageName;
  String? description;
  int? price;
  int? durationDays;

  Packages(
      {this.packageId,
      this.packageName,
      this.description,
      this.price,
      this.durationDays});

  Packages.fromJson(Map<String, dynamic> json) {
    packageId = json['package_id'];
    packageName = json['package_name'];
    description = json['description'];
    price = json['price'];
    durationDays = json['duration_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['package_id'] = this.packageId;
    data['package_name'] = this.packageName;
    data['description'] = this.description;
    data['price'] = this.price;
    data['duration_days'] = this.durationDays;
    return data;
  }
}
