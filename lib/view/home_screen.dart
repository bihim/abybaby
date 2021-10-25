import 'dart:convert';

import 'package:abybaby/api/api_requests.dart';
import 'package:abybaby/controller/home_screen_controller.dart';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:abybaby/model/time_model.dart';
import 'package:abybaby/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'components/arc_clipper.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());
  HomeScreen({Key? key}) : super(key: key);

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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 7.h,
                    ),
                    Image.asset(
                      "assets/abybaby.png",
                    ),
                    _profileInfo(),
                    _officeHours(),
                    _viewAttendance(),
                    IconButton(
                      onPressed: () {
                        final _boxes = GetStorage();
                        _boxes.write(GlobalVals.keyLog, false);
                        Get.offAllNamed(Routes.mobileNumber);
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _viewAttendance() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(2.h),
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed(Routes.attendance);
          //Get.to(TableMultiExample());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 2.h,
              ),
              child: const Icon(
                Icons.date_range,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            const Text(
              "View Attendance",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _officeHours() {
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              2.h,
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.h,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(2.h),
                    topRight: Radius.circular(2.h),
                  ),
                  color: GlobalVals.arcColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Office Hours",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    FutureBuilder<TimeModel?>(
                      future: _homeScreenController.getTime(),
                      builder: (context, snapShot) {
                        if (snapShot.hasData) {
                          return Text(
                            "${snapShot.data!.startTime} - ${snapShot.data!.endTime}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        } else if (snapShot.hasError) {
                          Text(
                            "${snapShot.error}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _homeScreenController.isClockable.value == true
                                ? Colors.green
                                : GlobalVals.arcColor,
                          ),
                        ),
                        onPressed: _homeScreenController.isClockLoaded.value == false ? null : _homeScreenController.isClockable.value ==
                                false
                            ? () {
                                Fluttertoast.showToast(
                                    msg: "You can not start your clock now");
                              }
                            : () async {
                                var _result =
                                    await _homeScreenController.setAttendance();
                                if (_result == null) {
                                  Fluttertoast.showToast(
                                      msg: "Attendance could not be set");
                                } else {
                                  if (_result.response == "success") {
                                    Fluttertoast.showToast(
                                        msg: _result.message);
                                    _homeScreenController.getClockIn();
                                  }
                                }
                              },
                        child: _homeScreenController
                                    .isAttendanceSubmittedLoading.value ==
                                true
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                _homeScreenController.isClockable.value == true
                                    ? "Clock In"
                                    : "Clock Out",
                              ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Current Time",
                          style: TextStyle(
                            color: GlobalVals.arcColor,
                          ),
                        ),
                        Column(
                          children: [
                            StreamBuilder(
                              stream:
                                  Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Center(
                                  child: Text(
                                    "${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 0.5.h,
                            ),
                            Text(
                              "Hours    Mins    Secs",
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(1.h),
                decoration: BoxDecoration(
                  color: GlobalVals.arcColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(2.h),
                    bottomRight: Radius.circular(2.h),
                  ),
                ),
                child: Obx(
                  () => Text(
                    _homeScreenController.address.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _profileInfo() {
    var _box = Hive.box(GlobalVals.userValues);
    String _getResult = _box.get(GlobalVals.keyValues);
    Datum _data = OtpModel.fromJson(json.decode(_getResult)).data.first;
    _homeScreenController.uid.value = _data.uid.toString();
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              2.h,
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 2.h,
              vertical: 4.h,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    3.h,
                  ),
                  child: Image.asset(
                    "assets/john_doe.jpg",
                    height: 20.h,
                    width: 37.w,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 2.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                _data.name,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              _data.email,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            /* Text(
                              "AB-00001",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ), */
                          ],
                        ),
                      ),
                      Container(
                        height: 0.1.h,
                        color: Colors.grey.shade300,
                        width: 43.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 2.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _data.designationName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _data.depName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: Text(
                                _data.branchName,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
