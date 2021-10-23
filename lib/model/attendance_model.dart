// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) =>
    AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) =>
    json.encode(data.toJson());

class AttendanceModel {
  String response;
  String message;
  AttendanceModel({
    required this.response,
    required this.message,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
