class Equipment {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Equipment({this.data, this.message, this.statusCode, this.date});

  Equipment.fromJson(Map<String, dynamic> json) {
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
  int? equipmentId;
  String? equipmentName;
  String? description;
  String? location;
  String? status;
  String? lastMaintenanceDate;
  String? createdAt;

  Data(
      {this.equipmentId,
      this.equipmentName,
      this.description,
      this.location,
      this.status,
      this.lastMaintenanceDate,
      this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    equipmentId = json['equipment_id'];
    equipmentName = json['equipment_name'];
    description = json['description'];
    location = json['location'];
    status = json['status'];
    lastMaintenanceDate = json['last_maintenance_date'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['equipment_id'] = this.equipmentId;
    data['equipment_name'] = this.equipmentName;
    data['description'] = this.description;
    data['location'] = this.location;
    data['status'] = this.status;
    data['last_maintenance_date'] = this.lastMaintenanceDate;
    data['created_at'] = this.createdAt;
    return data;
  }
}
