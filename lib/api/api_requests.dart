import 'dart:convert';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/otp_model.dart';
import 'package:abybaby/model/time_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiRequest {
  static Future<String?> getOtp(String number) async {
    final Map<String, dynamic> body = {'mobile_no': number};
    var response = await http.post(
      Uri.parse(GlobalVals.baseUrl + GlobalVals.otpEndPoint),
      body: body,
    );
    if (response.statusCode == 200) {
      var _logger = Logger();
      _logger.d(response.body);
      return response.body;
    } else {
      return null;
    }
  }
}
