import 'dart:async';
import 'dart:convert';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/attendance_model.dart';
import 'package:abybaby/model/clock_model.dart';
import 'package:abybaby/model/time_model.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class HomeScreenController extends GetxController {
  var address = "".obs;
  var lat = 0.0.obs;
  var long = 0.0.obs;
  var isClockable = true.obs;
  var latlong = "".obs;
  var uid = "0".obs;
  var isAttendanceSubmittedLoading = false.obs;
  var isClockLoaded = false.obs;

  var timeDifInHour = "00".obs;
  var timeDifInMinute = "00".obs;
  var timeDifInSeconds = "00".obs;
  var buttonText = "Clock In".obs;

  @override
  void onInit() async {
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream().listen((Position position) async {
      final coordinates = Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print(position == null
          ? 'Unknown'
          : position.latitude.toString() +
              ', ' +
              position.longitude.toString());

      print("${first.addressLine}");
      address.value = "${first.addressLine}";
      lat.value = position.latitude;
      long.value = position.longitude;
      latlong.value =
          position.latitude.toString() + "," + position.longitude.toString();
    });
    await Hive.openBox(GlobalVals.userValues);
    await getClockIn();
    super.onInit();
  }

  Future<AttendanceModel?> setAttendance() async {
    isAttendanceSubmittedLoading.value = true;
    final Map<String, dynamic> body = {
      'uid': uid.value,
      'latlong': latlong.value,
      'address': address.value
    };
    var response = await http.post(
      Uri.parse(GlobalVals.baseUrl + GlobalVals.attendanceEndPoint),
      body: body,
    );
    if (response.statusCode == 200) {
      isAttendanceSubmittedLoading.value = false;
      var _logger = Logger();
      _logger.d(response.body);
      return AttendanceModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }

  Future getClockIn() async {
    isClockLoaded.value = false;
    final Map<String, dynamic> body = {
      'uid': uid.value,
    };
    var response = await http.post(
      Uri.parse(GlobalVals.baseUrl + GlobalVals.checkAttendanceEndPoint),
      body: body,
    );
    var _logger = Logger();
    _logger.d("I am at clock");
    _logger.d(response.body);
    if (response.statusCode == 200) {
      isClockLoaded.value = true;
      var _result = ClockModel.fromJson(json.decode(response.body));
      if (_result.message == "Clock-out") {
        buttonText.value = "Clock Out";
        isClockable.value = true;
      } else if (_result.message == "Complete") {
        buttonText.value = "Complete";
        isClockable.value = false;
      } else {
        buttonText.value = "Clock In";
        isClockable.value = true;
      }
    } else {
      isClockLoaded.value = true;
      Fluttertoast.showToast(msg: "Something went wrong");
      isClockable.value = false;
    }
  }

  Future<TimeModel?> getTime() async {
    var response = await http.get(
      Uri.parse(GlobalVals.baseUrl + GlobalVals.timeEndPoint),
    );
    if (response.statusCode == 200) {
      var _logger = Logger();
      var _now = DateTime.now();
      var snapShot = TimeModel.fromJson(json.decode(response.body));
      var _startString = snapShot.startTime.split(":");
      var _endString = snapShot.endTime.split(":");
      var _startTime = DateTime(_now.year, _now.month, _now.day,
          int.parse(_startString[0]), int.parse(_startString[1]));
      var _endTime = DateTime(_now.year, _now.month, _now.day,
          int.parse(_endString[0]), int.parse(_endString[1]));
      var _nowEpoch = _now.millisecondsSinceEpoch;
      var _startTimeEpoch = _startTime.millisecondsSinceEpoch;
      var _endTimeEpoch = _endTime.millisecondsSinceEpoch;

      return TimeModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
