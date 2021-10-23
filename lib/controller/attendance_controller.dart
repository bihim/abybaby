import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/month_report_model.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

class AttendanceController extends GetxController {
  final _box = Hive.box(GlobalVals.userValues);
  final _now = DateTime.now();
  var uid = "".obs;
  var dateTime = "".obs;
  var selectedDateTime = DateTime.now().obs;
  var isDateLoading = false.obs;
  var cellCalendarPageController = CellCalendarPageController();
  var responseString = "".obs;
  final _logger = Logger();
  var isNull = false.obs;
  RxList<CalendarEvent> calendarEvents = [
    CalendarEvent(
      eventName: "",
      eventDate: DateTime(1999, 01, 01),
      eventBackgroundColor: Colors.white,
    ),
  ].obs;

  @override
  void onInit() {
    String _getResult = _box.get(GlobalVals.keyValues);
    Datum _data = OtpModel.fromJson(json.decode(_getResult)).data.first;
    uid.value = _data.uid.toString();
    dateTime.value = "${getMonthName(_now)}, ${_now.year}";
    getMonthReport();
    super.onInit();
  }

  getMonthName(DateTime date) {
    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';
    return json.decode(monthData)['${date.month}'];
  }

  Future<MonthReportModel?> getMonthReport() async {
    final _lastday = DateTime(
            selectedDateTime.value.year, selectedDateTime.value.month + 1, 0)
        .day;
    isDateLoading.value = true;
    final Map<String, dynamic> body = {
      'uid': uid.value,
      's_date':
          "${selectedDateTime.value.year}-${selectedDateTime.value.month}-01",
      'e_date':
          "${selectedDateTime.value.year}-${selectedDateTime.value.month}-$_lastday",
    };
    try {
      var response = await http.post(
        Uri.parse(GlobalVals.baseUrl + GlobalVals.monthEndPoint),
        body: body,
      );
      if (response.statusCode == 200) {
        isNull.value = false;
        isDateLoading.value = false;
        var _monthlyReport =
            MonthReportModel.fromJson(json.decode(response.body));
        responseString.value = response.body;
        _logger.d("Calender Response: ${response.body}");
        calendarEvents.clear();
        for (var data in _monthlyReport.data) {
          var getDate = data.date;
          calendarEvents.add(
            CalendarEvent(
              eventName: data.status,
              eventDate: getDate,
              eventBackgroundColor:
                  data.status == "Present" ? Colors.green : Colors.red,
            ),
          );
        }
        return MonthReportModel.fromJson(json.decode(response.body));
      } else {
        return null;
      }
    } on Error catch (e) {
      _logger.e(e.toString());
      _logger.d("I am in catch");
      isNull.value = true;
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
