// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  OtpModel({
    required this.response,
    required this.message,
    required this.data,
  });

  String response;
  String message;
  List<Datum> data;

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
        response: json["response"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String uid;
  String name;
  DateTime dob;
  String gender;
  String email;
  String employeeId;
  String branchId;
  String branchName;
  String departmentId;
  String depName;
  String designationId;
  String designationName;
  int otp;
  Datum({
    required this.uid,
    required this.name,
    required this.dob,
    required this.gender,
    required this.email,
    required this.employeeId,
    required this.branchId,
    required this.branchName,
    required this.departmentId,
    required this.depName,
    required this.designationId,
    required this.designationName,
    required this.otp,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        uid: json["uid"],
        name: json["name"],
        dob: DateTime.parse(json["dob"]),
        gender: json["gender"],
        email: json["email"],
        employeeId: json["employee_id"],
        branchId: json["branch_id"],
        branchName: json["branch_name"],
        departmentId: json["department_id"],
        depName: json["dep_name"],
        designationId: json["designation_id"],
        designationName: json["designation_name"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "dob":
            "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "email": email,
        "employee_id": employeeId,
        "branch_id": branchId,
        "branch_name": branchName,
        "department_id": departmentId,
        "dep_name": depName,
        "designation_id": designationId,
        "designation_name": designationName,
        "otp": otp,
      };
}
