import 'dart:async';
import 'dart:convert';
import 'package:abybaby/global/global.dart';
import 'package:abybaby/model/attendance_model.dart';
import 'package:abybaby/model/time_model.dart';
import 'package:flutter_geocoder/geocoder.dart';
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

  var timeDifInHour = "00".obs;
  var timeDifInMinute = "00".obs;
  var timeDifInSeconds = "00".obs;

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

      print("Address: ${first.featureName} : ${first.addressLine}");
      address.value = "Address: ${first.featureName} : ${first.addressLine}";
      lat.value = position.latitude;
      long.value = position.longitude;
      latlong.value =
          position.latitude.toString() + "," + position.longitude.toString();
    });
    await Hive.openBox(GlobalVals.userValues);
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

      if (_now.hour >= _startTime.hour) {
        if (_now.hour <= _endTime.hour) {
          if (_now.minute <= _endTime.minute) {
            timeDifInHour.value =
                _now.difference(_startTime).inHours.toString();
            timeDifInMinute.value = _now.minute.toString();
            timeDifInSeconds.value = _now.second.toString();
            isClockable.value = true;
            _logger.d("Clockable true in if->if->if");
          } else {
            isClockable.value = false;
            _logger.d("Clockable false in if->if->else");
          }
        } else {
          isClockable.value = false;
          _logger.d("Clockable false in if->else");
        }
      } else {
        isClockable.value = false;
        _logger.d("Clockable false in else");
      }

      return TimeModel.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
