// To parse this JSON data, do
//
//     final clockModel = clockModelFromJson(jsonString);

import 'dart:convert';

ClockModel clockModelFromJson(String str) =>
    ClockModel.fromJson(json.decode(str));

String clockModelToJson(ClockModel data) => json.encode(data.toJson());

class ClockModel {
  String response;
  String message;
  ClockModel({
    required this.response,
    required this.message,
  });

  factory ClockModel.fromJson(Map<String, dynamic> json) => ClockModel(
        response: json["response"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "response": response,
        "message": message,
      };
}
