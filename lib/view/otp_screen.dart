import 'dart:convert';

import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:abybaby/routes/routes.dart';
import 'package:abybaby/view/components/arc_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text("Home"),
      ), */
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
                  "assets/abybaby.png",
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
                            "Enter OTP",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          PinCodeTextField(
                            length: 4,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            keyboardType: TextInputType.number,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(5),
                              fieldHeight: 7.h,
                              fieldWidth: 14.w,
                              activeFillColor: Colors.white,
                              inactiveFillColor: Colors.white,
                              inactiveColor: Colors.grey.shade300,
                              selectedColor: Colors.blue,
                              selectedFillColor: Colors.white,
                              activeColor: Colors.blue,
                            ),
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: true,
                            onCompleted: (v) async {
                              print("Completed $v");
                              final _boxes = GetStorage();
                              var _box =
                                  await Hive.openBox(GlobalVals.userValues);
                              String _getResult =
                                  _box.get(GlobalVals.keyValues);
                              Datum _data =
                                  OtpModel.fromJson(json.decode(_getResult))
                                      .data
                                      .first;
                              if (_data.otp == int.parse(v)) {
                                Get.offNamed(Routes.home);
                                _boxes.write(GlobalVals.keyLog, true);
                              }
                            },
                            onChanged: (value) {
                              print("onChanged: $value");
                            },
                            beforeTextPaste: (text) {
                              print("Allowing to paste $text");
                              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                              //but you can show anything you want here, like your pop up saying wrong paste format or etc
                              return true;
                            },
                            appContext: context,
                          ),
                          /*  SizedBox(
                            height: 3.h,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.home);
                            },
                            child: const Text("Validate OTP"),
                          ), */
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
