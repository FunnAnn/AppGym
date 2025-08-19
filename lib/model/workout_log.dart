class Workout_logs {
  List<Data>? data;
  String? message;
  int? statusCode;
  String? date;

  Workout_logs({this.data, this.message, this.statusCode, this.date});

  Workout_logs.fromJson(Map<String, dynamic> json) {
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
  int? logId;
  int? actualSets;
  int? actualReps;
  int? actualWeight;
  String? notes;
  String? workoutDate;
  TrainingPlans? trainingPlans;
  Exercise? exercise;
  Coaches? coaches;
  Customer? customer;

  Data(
      {this.logId,
      this.actualSets,
      this.actualReps,
      this.actualWeight,
      this.notes,
      this.workoutDate,
      this.trainingPlans,
      this.exercise,
      this.coaches,
      this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    logId = json['log_id'];
    actualSets = json['actual_sets'];
    actualReps = json['actual_reps'];
    actualWeight = json['actual_weight'];
    notes = json['notes'];
    workoutDate = json['workout_date'];
    trainingPlans = json['training_plans'] != null
        ? new TrainingPlans.fromJson(json['training_plans'])
        : null;
    exercise = json['exercise'] != null
        ? new Exercise.fromJson(json['exercise'])
        : null;
    coaches =
        json['coaches'] != null ? new Coaches.fromJson(json['coaches']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['log_id'] = this.logId;
    data['actual_sets'] = this.actualSets;
    data['actual_reps'] = this.actualReps;
    data['actual_weight'] = this.actualWeight;
    data['notes'] = this.notes;
    data['workout_date'] = this.workoutDate;
    if (this.trainingPlans != null) {
      data['training_plans'] = this.trainingPlans!.toJson();
    }
    if (this.exercise != null) {
      data['exercise'] = this.exercise!.toJson();
    }
    if (this.coaches != null) {
      data['coaches'] = this.coaches!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    return data;
  }
}

class TrainingPlans {
  int? planId;
  String? description;
  String? dietPlan;

  TrainingPlans({this.planId, this.description, this.dietPlan});

  TrainingPlans.fromJson(Map<String, dynamic> json) {
    planId = json['plan_id'];
    description = json['description'];
    dietPlan = json['diet_plan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_id'] = this.planId;
    data['description'] = this.description;
    data['diet_plan'] = this.dietPlan;
    return data;
  }
}

class Exercise {
  int? exerciseId;
  String? name;
  String? description;
  String? muscleGroup;
  String? equipment;
  String? videoUrl;

  Exercise(
      {this.exerciseId,
      this.name,
      this.description,
      this.muscleGroup,
      this.equipment,
      this.videoUrl});

  Exercise.fromJson(Map<String, dynamic> json) {
    exerciseId = json['exercise_id'];
    name = json['name'];
    description = json['description'];
    muscleGroup = json['muscleGroup'];
    equipment = json['equipment'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['exercise_id'] = this.exerciseId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['muscleGroup'] = this.muscleGroup;
    data['equipment'] = this.equipment;
    data['videoUrl'] = this.videoUrl;
    return data;
  }
}

class Coaches {
  int? coachId;
  String? fullName;
  String? email;
  String? dateOfBirth;
  String? phoneNumber;
  String? avatar;

  Coaches(
      {this.coachId,
      this.fullName,
      this.email,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatar});

  Coaches.fromJson(Map<String, dynamic> json) {
    coachId = json['coach_id'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coach_id'] = this.coachId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Customer {
  int? customerId;
  String? fullName;
  String? email;
  String? dateOfBirth;
  String? phoneNumber;
  String? avatar;

  Customer(
      {this.customerId,
      this.fullName,
      this.email,
      this.dateOfBirth,
      this.phoneNumber,
      this.avatar});

  Customer.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    fullName = json['full_name'];
    email = json['email'];
    dateOfBirth = json['date_of_birth'];
    phoneNumber = json['phone_number'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_number'] = this.phoneNumber;
    data['avatar'] = this.avatar;
    return data;
  }
}
