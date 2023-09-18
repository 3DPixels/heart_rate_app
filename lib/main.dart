import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heart_rate_app/screens/welcome_page.dart';
import 'package:heart_rate_app/services/database_helper.dart';
import 'package:heart_rate_app/services/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'local/cach_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await DatabaseHelper().createDatabase();
  await Permission.notification.request();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return child!;
      },
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Heart Rate App',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
