import 'dart:async';

import 'package:BBBS/Views/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:BBBS/Controllers/AuthController.dart';
import 'package:BBBS/Models/Utils/Colors.dart';
import 'package:BBBS/Models/Utils/Common.dart';
import 'package:BBBS/Models/Utils/Images.dart';
import 'package:BBBS/Models/Utils/Routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    displaySize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorWhite,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: displaySize.width * 0.4,
                child: Image.asset(logo),
              )),
        ],
      )),
    );
  }

  Future<void> startApp() async {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      _timer!.cancel();
      Routes(context: context).navigateReplace(const Login());
    });
  }
}
