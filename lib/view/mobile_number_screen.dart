import 'dart:convert';

import 'package:abybaby/api/api_requests.dart';
import 'package:abybaby/controller/otp_controller.dart';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:abybaby/routes/routes.dart';
import 'package:abybaby/view/components/arc_clipper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MobileNumberScreen extends StatelessWidget {
  final _textEditingController = TextEditingController();
  final _otpController = Get.put(OtpController());
  final _loading = false.obs;
  MobileNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final _box = GetStorage();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80.h,
              width: double.infinity,
              child: ClipPath(
                clipper: ArcClipper(),
                child: Container(
                  height: 80.h,
                  color: GlobalVals.arcColor,
                ),
              ),
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  "assets/logo.png",
                  height: 12.h,
                  width: 79.w,
                  fit: BoxFit.fill,
                ),
                Image.asset(
                  "assets/run.png",
                  height: 15.h,
                  width: 35.w,
                  color: Colors.white,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.h,
                  ),
                  child: Card(
                    elevation: 1.h,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.h),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            "Enter Mobile Number",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          TextField(
                            controller: _textEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.mobile_friendly,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: GlobalVals.arcColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.h,
                            ),
                            width: double.infinity,
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: () async {
                                  _otpController
                                      .getOtp(_textEditingController.text);
                                },
                                child: _otpController.isLoading.value == false
                                    ? const Text("Get OTP")
                                    : const CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
