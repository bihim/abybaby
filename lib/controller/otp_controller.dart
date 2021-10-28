import 'package:abybaby/routes/routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:abybaby/model/time_model.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class OtpController extends GetxController {
  final _logger = Logger();
  var isNull = false.obs;
  var isLoading = false.obs;
  Future<String?> getOtp(String number) async {
    isLoading.value = true;
    final Map<String, dynamic> body = {'mobile_no': number};
    try {
      var response = await http.post(
        Uri.parse(GlobalVals.baseUrl + GlobalVals.otpEndPoint),
        body: body,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        isNull.value = false;
        _logger.d(response.body);
        var _result = OtpModel.fromJson(json.decode(response.body));
        if (_result.response == "success") {
          var _logger = Logger();
          var _box = await Hive.openBox(GlobalVals.userValues);
          _box.put(GlobalVals.keyValues, response.body);
          _logger.i(_result.data.first.otp);
          Get.toNamed(Routes.otp);
        } else {
          Fluttertoast.showToast(msg: _result.response);
        }
        return response.body;
      } else {
        Fluttertoast.showToast(msg: "Server Error");
        isLoading.value = false;
        return null;
      }
    } on Error catch (e) {
      isLoading.value = false;
      isNull.value = true;
      _logger.e(e.toString());
      _logger.d("I am in catch otp");
      Fluttertoast.showToast(msg: "Invalid Mobile No.");
    }
  }
}
