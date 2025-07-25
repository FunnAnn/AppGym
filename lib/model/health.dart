class Health {
  Data? data;
  String? message;
  int? statusCode;
  String? date;

  Health({this.data, this.message, this.statusCode, this.date});

  Health.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    data['date'] = date;
    return data;
  }
}

class Data {
  int? healthId;
  int? userId;
  double? height;
  double? weight;
  int? age;
  bool? gender;
  double? bmi;
  String? bmiStatus;
  String? createdAt;
  String? updatedAt;

  Data({
    this.healthId,
    this.userId,
    this.height,
    this.weight,
    this.age,
    this.gender,
    this.bmi,
    this.bmiStatus,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    healthId = json['health_id'];
    userId = json['user_id'];
    height = json['height']?.toDouble();
    weight = json['weight']?.toDouble();
    age = json['age'];
    gender = json['gender'];
    bmi = json['bmi']?.toDouble();
    bmiStatus = json['bmi_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['health_id'] = healthId;
    data['user_id'] = userId;
    data['height'] = height;
    data['weight'] = weight;
    data['age'] = age;
    data['gender'] = gender;
    data['bmi'] = bmi;
    data['bmi_status'] = bmiStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
