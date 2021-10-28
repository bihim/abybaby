import 'package:abybaby/global/global.dart';
import 'package:abybaby/routes/routes.dart';
import 'package:abybaby/view/attendance_screen.dart';
import 'package:abybaby/view/home_screen.dart';
import 'package:abybaby/view/mobile_number_screen.dart';
import 'package:abybaby/view/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  await GetStorage.init();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  await Hive.openBox(GlobalVals.userValues);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        final _box = GetStorage();
        bool _isLoggedIn = _box.read(GlobalVals.keyLog) ?? false;
        _hiveBox(_isLoggedIn);
        return GetMaterialApp(
          title: "Abybaby Attendance",
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: _isLoggedIn == true ? Routes.home : Routes.mobileNumber,
          getPages: [
            GetPage(
              name: Routes.mobileNumber,
              page: () => MobileNumberScreen(),
            ),
            GetPage(
              name: Routes.otp,
              page: () => const OtpScreen(),
            ),
            GetPage(
              name: Routes.home,
              page: () => HomeScreen(),
            ),
            GetPage(
              name: Routes.attendance,
              page: () => AttendanceScreen(),
            ),
          ],
        );
      },
    );
  }

  _hiveBox(bool isLoggedIn) async {
    if (isLoggedIn) {
      await Hive.openBox(GlobalVals.userValues);
    }
  }
}
