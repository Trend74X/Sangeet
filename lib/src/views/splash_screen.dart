import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sangeet/src/controller/audio_controller.dart';
import 'package:sangeet/src/widgets/cache_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AudioController _con = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool isDarkMode = read('isDarkMode') == null || read('isDarkMode') == '' 
                          ? defaultDarkMode()
                          : read('isDarkMode') == true
                            ? true
                            : false;
      Get.changeThemeMode(
        isDarkMode ? ThemeMode.dark : ThemeMode.light
      );
    });
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => _con.getAllFiles()
      // Get.off(() => const BottomNavigation())
    );
  }

  defaultDarkMode() {
    write('isDarkMode', Get.isDarkMode);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Image.asset('assets/images/appIcon.png')
        )
      )
    );
  }
  
}