class Package {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Package({this.data, this.message, this.statusCode, this.date});

  Package.fromJson(Map<String, dynamic> json) {
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
  int? packageId;
  String? packageName;
  String? description;
  int? price;
  int? durationDays;

  Data(
      {this.packageId,
      this.packageName,
      this.description,
      this.price,
      this.durationDays});

  Data.fromJson(Map<String, dynamic> json) {
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
