class Excercise {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Excercise({this.data, this.message, this.statusCode, this.date});

  Excercise.fromJson(Map<String, dynamic> json) {
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
  int? exerciseId;
  String? exerciseName;
  String? description;
  String? muscleGroup;
  String? equipmentNeeded;
  String? videoUrl;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.exerciseId,
      this.exerciseName,
      this.description,
      this.muscleGroup,
      this.equipmentNeeded,
      this.videoUrl,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    exerciseId = json['exercise_id'];
    exerciseName = json['exercise_name'];
    description = json['description'];
    muscleGroup = json['muscle_group'];
    equipmentNeeded = json['equipment_needed'];
    videoUrl = json['video_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exercise_id'] = this.exerciseId;
    data['exercise_name'] = this.exerciseName;
    data['description'] = this.description;
    data['muscle_group'] = this.muscleGroup;
    data['equipment_needed'] = this.equipmentNeeded;
    data['video_url'] = this.videoUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
