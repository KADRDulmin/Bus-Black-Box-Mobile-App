import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:BBBS/Models/Strings/app.dart';
import 'package:BBBS/Models/Utils/Colors.dart';
import 'package:BBBS/Views/Init/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  initializeNotifications();
  requestPermissions(); // Add this line to request permissions

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  runApp(MyApp());
}

void initializeNotifications() {
  print("Initializing notifications...");

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'emergency_BBBS',
          channelKey: 'emergency_BBBS',
          channelName: 'BBBS notifications',
          channelDescription: 'Notification from BBBS',
          defaultColor: colorPrimary,
          ledColor: color7,
          locked: true,
          importance: NotificationImportance.Max,
          playSound: true,
          soundSource: 'resource://raw/alarm',
          vibrationPattern: highVibrationPattern,
          channelShowBadge: true,

        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'emergency_BBBS', channelGroupName: 'BBBS group'
        )
      ],
      debug: true
  ).then((_) {
    print("Notification initialization successful!");
  }).catchError((error) {
    print("Error initializing notifications: $error");
  });
}

// Define the requestPermissions function to request necessary permissions
void requestPermissions() async {
  // Request permission to access the external storage
  PermissionStatus status = await Permission.storage.request();

  // Check if permission is granted
  if (status.isGranted) {
    // Permission is granted, you can proceed with accessing the audio file
  } else {
    // Permission is denied, handle accordingly (e.g., show a message to the user)
  }
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: colorPrimary,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: colorDarkBg,
        statusBarIconBrightness: Brightness.light));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: app_name,
      theme: ThemeData(
        fontFamily: 'Raleway-Medium',
        primarySwatch: MaterialColor(0xFF030303, color),
        unselectedWidgetColor: color7,
      ),
      home: const SplashScreen(),
    );
  }

  Map<int, Color> color = {
    50: color3,
    100: color3,
    200: color3,
    300: color3,
    400: color3,
    500: color3,
    600: color3,
    700: color3,
    800: color3,
    900: color3,
  };
}
