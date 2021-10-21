import 'package:abybaby/routes/routes.dart';
import 'package:abybaby/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: "AbyBaby",
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: "Sans Fransisco Pro",
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.home,
          getPages: [
            GetPage(
              name: Routes.home,
              page: () => const HomeScreen(),
            ),
          ],
        );
      },
    );
  }
}
