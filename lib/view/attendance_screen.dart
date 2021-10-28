import 'dart:convert';
import 'package:abybaby/controller/attendance_controller.dart';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/month_report_model.dart';
import 'package:abybaby/view/sample_data.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'components/arc_clipper.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

class AttendanceScreen extends StatelessWidget {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());
  var _logger = Logger();
  AttendanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 40.h,
              width: double.infinity,
              child: ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  height: 40.h,
                  color: GlobalVals.arcColor,
                ),
              ),
            ),
          ),
          Positioned(
            child: SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 3.h,
                    ),
                    Image.asset(
                      "assets/logo.png",
                      height: 12.h,
                      width: 79.w,
                      fit: BoxFit.fill,
                    ),
                    _attendanceSummery(context),
                    //_calendarAll(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _calendarAll() {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: Card(
        elevation: 2.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            3.h,
          ),
        ),
        child: Container(
          height: 65.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              2.h,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Obx(() => _calendar()),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _status(Colors.green, "Present"),
                  _status(Colors.red, "Absent"),
                  _status(Colors.orange, "Holiday"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _calendar() {
    return SizedBox(
      height: 60.h,
      child: CellCalendar(
        cellCalendarPageController:
            _attendanceController.cellCalendarPageController,
        daysOfTheWeekBuilder: (dayIndex) {
          /// dayIndex: 0 for Sunday, 6 for Saturday.
          final labels = ["S", "M", "T", "W", "T", "F", "S"];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              labels[dayIndex],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: dayIndex == 0 ? Colors.red : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        events: _attendanceController.calendarEvents.value,
        onCellTapped: (dateTime) {
          if (_attendanceController.responseString.value == "") {
            Get.defaultDialog(
              title: "Attendance",
              middleText: "No data available",
            );
          } else {
            var _monthlyReport = MonthReportModel.fromJson(
                json.decode(_attendanceController.responseString.value));
            if (_attendanceController.isNull.value == false) {
              for (var data in _monthlyReport.data) {
                if (data.date.day == dateTime.day) {
                  Get.defaultDialog(
                    title: "Day Summery",
                    content: Column(
                      children: [
                        Text(
                          "Date: ${data.date.year}, ${data.date.month}, ${data.date.day}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Clock In: ${data.clockIn}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Clock out: ${data.clockOut}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Early leave: ${data.earlyLeaving}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Overtime: ${data.overtime}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Total Rest: ${data.totalRest}",
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          "Status: ${data.status}",
                        ),
                      ],
                    ),
                  );
                }
              }
            } else {
              Get.defaultDialog(
                title: "Attendance",
                middleText: "No data available",
              );
            }
          }
          print(dateTime.day);
        },
        monthYearLabelBuilder: (datetime) {
          final year = datetime!.year.toString();
          final month = datetime.month.monthName;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Text(
                  "$month  $year",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
    /* return FutureBuilder<MonthReportModel?>(
      future: _attendanceController.getMonthReport(),
      builder: (context, snapShot) {
        if (!snapShot.hasData) {
          Fluttertoast.showToast(msg: snapShot.error.toString());
        } else if (snapShot.hasError) {
          Fluttertoast.showToast(msg: snapShot.error.toString());
        } else {
          if (snapShot.data!.status == "success") {
            return Container();
          } else {
            Fluttertoast.showToast(msg: snapShot.data!.message.toString());
          }
        }
        return SizedBox(
          height: 60.h,
          child: CellCalendar(
            cellCalendarPageController:
                _attendanceController.cellCalendarPageController,
            daysOfTheWeekBuilder: (dayIndex) {
              /// dayIndex: 0 for Sunday, 6 for Saturday.
              final labels = ["S", "M", "T", "W", "T", "F", "S"];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  labels[dayIndex],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dayIndex == 0 ? Colors.red : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
            events: _attendanceController.calendarEvents,
            onCellTapped: (dateTime) {
              print(dateTime.day);
            },
            monthYearLabelBuilder: (datetime) {
              final year = datetime!.year.toString();
              final month = datetime.month.monthName;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      "$month  $year",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
          ),
        );
      },
    ); */
  }

  Row _status(Color color, String text) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: color,
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
          ),
        )
      ],
    );
  }

  Padding _attendanceSummery(var context) {
    return Padding(
      padding: EdgeInsets.all(2.h),
      child: Card(
        elevation: 1.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            3.h,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              2.h,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(2.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      2.h,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_rounded,
                        ),
                        Obx(
                          () => Text(
                            _attendanceController.dateTime.value,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                        ),
                      ],
                    ),
                    onTap: () {
                      String _format = 'yyyy-MMMM';
                      DateTime _now = DateTime.now();
                      DatePicker.showDatePicker(
                        context,
                        onMonthChangeStartWithFirstDate: true,
                        pickerTheme: const DateTimePickerTheme(
                          showTitle: true,
                          confirm: Text(
                            'Done',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                        minDateTime: DateTime.parse('2011-01-01'),
                        maxDateTime: DateTime(_now.year, _now.month),
                        initialDateTime: _now,
                        dateFormat: _format,
                        onClose: () => print("----- onClose -----"),
                        onCancel: () => print('onCancel'),
                        onChange: (dateTime, List<int> index) {
                          /* setState(() {
                            _dateTime = dateTime;
                          }); */
                          /* _attendanceController.cellCalendarPageController
                              .animateToDate(dateTime,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceIn); */
                          print("Change: $dateTime");
                        },
                        onConfirm: (dateTime, List<int> index) {
                          /* setState(() {
                            _dateTime = dateTime;
                          }); */
                          _attendanceController.dateTime.value =
                              "${_attendanceController.getMonthName(dateTime)}, ${dateTime.year}";
                          /* _attendanceController.cellCalendarPageController
                              .animateToDate(dateTime,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceIn); */
                          _attendanceController.selectedDateTime.value =
                              dateTime;
                          _attendanceController.getMonthReport();
                          print("Confirm: $dateTime");
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                height: 0.2.h,
                color: Colors.grey.shade300,
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                  left: 2.h,
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Attendance Summery",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          _attendanceController.responseString.value == ""
                              ? "No summery available"
                              : "Days Absent: ${(DateTime.now().day) - (MonthReportModel.fromJson(json.decode(_attendanceController.responseString.value)).data.length)}",
                          style: TextStyle(fontSize: 14.sp),
                        )),
                    Obx(() => Text(
                          _attendanceController.responseString.value == ""
                              ? ""
                              : "Days Present: ${MonthReportModel.fromJson(json.decode(_attendanceController.responseString.value)).data.length}",
                          style: TextStyle(fontSize: 14.sp),
                        )),
                  ],
                ),
              ),
              /* Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(
                        _attendanceController.responseString.value == ""
                            ? ""
                            : "Days Absent: ${(DateTime.now().day) - (MonthReportModel.fromJson(json.decode(_attendanceController.responseString.value)).data.length)}",
                        style: TextStyle(fontSize: 14.sp),
                      )),
                ],
              ), */
              Obx(() => SizedBox(
                    child: _attendanceController.isDateLoading.value == false
                        ? const SizedBox()
                        : const CircularProgressIndicator(
                            color: GlobalVals.arcColor,
                          ),
                  )),
              Obx(
                () => SizedBox(
                  child: _attendanceController.responseString.value == ""
                      ? const SizedBox()
                      : Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              color: GlobalVals.arcColor,
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Date",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Clock In",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Clock Out",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: MonthReportModel.fromJson(
                                        json.decode(_attendanceController
                                            .responseString.value))
                                    .data
                                    .length,
                                itemBuilder: (context, index) {
                                  var _value = MonthReportModel.fromJson(
                                          json.decode(_attendanceController
                                              .responseString.value))
                                      .data;
                                  _logger.d(
                                      "${_value[index].date.day}/${_value[index].date.month}/${_value[index].date.year}");
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${_value[index].date.day}/${_value[index].date.month}/${_value[index].date.year}",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _value[index].clockIn,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            _value[index].clockOut,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    height: 0.2.h,
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  int daysInMonth(DateTime date) => DateTimeRange(
          start: DateTime(date.year, date.month, 1),
          end: DateTime(date.year, date.month + 1))
      .duration
      .inDays;
}
