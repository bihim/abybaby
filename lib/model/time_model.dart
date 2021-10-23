// To parse this JSON data, do
//
//     final timeModel = timeModelFromJson(jsonString);

import 'dart:convert';

TimeModel timeModelFromJson(String str) => TimeModel.fromJson(json.decode(str));

String timeModelToJson(TimeModel data) => json.encode(data.toJson());

class TimeModel {
  String response;
  String message;
  String startTime;
  String endTime;
  TimeModel({
    required this.response,
    required this.message,
    required this.startTime,
    required this.endTime,
  });

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
        response: json["response"],
        message: json["message"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
        "start_time": startTime,
        "end_time": endTime,
      };
}
