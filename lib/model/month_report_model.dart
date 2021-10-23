// To parse this JSON data, do
//
//     final monthReportModel = monthReportModelFromJson(jsonString);

import 'dart:convert';

MonthReportModel monthReportModelFromJson(String str) =>
    MonthReportModel.fromJson(json.decode(str));

String monthReportModelToJson(MonthReportModel data) =>
    json.encode(data.toJson());

class MonthReportModel {
  String status;
  String message;
  List<Datumm> data;
  MonthReportModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MonthReportModel.fromJson(Map<String, dynamic> json) =>
      MonthReportModel(
        status: json["status"],
        message: json["message"],
        data: List<Datumm>.from(json["data"].map((x) => Datumm.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datumm {
  String id;
  DateTime date;
  String status;
  String clockIn;
  String clockOut;
  String earlyLeaving;
  String overtime;
  String totalRest;
  String sLatlong;
  String sAddress;
  String eLatlong;
  String eAddress;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;
  Datumm({
    required this.id,
    required this.date,
    required this.status,
    required this.clockIn,
    required this.clockOut,
    required this.earlyLeaving,
    required this.overtime,
    required this.totalRest,
    required this.sLatlong,
    required this.sAddress,
    required this.eLatlong,
    required this.eAddress,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Datumm.fromJson(Map<String, dynamic> json) => Datumm(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        status: json["status"],
        clockIn: json["clock_in"],
        clockOut: json["clock_out"],
        earlyLeaving: json["early_leaving"],
        overtime: json["overtime"],
        totalRest: json["total_rest"],
        sLatlong: json["s_latlong"],
        sAddress: json["s_address"],
        eLatlong: json["e_latlong"],
        eAddress: json["e_address"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
        "clock_in": clockIn,
        "clock_out": clockOut,
        "early_leaving": earlyLeaving,
        "overtime": overtime,
        "total_rest": totalRest,
        "s_latlong": sLatlong,
        "s_address": sAddress,
        "e_latlong": eLatlong,
        "e_address": eAddress,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
