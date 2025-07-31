import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:new_version_plus/new_version_plus.dart';
import 'package:open_store/open_store.dart';
import 'package:version/version.dart';

class AppController extends GetxController {
  RxBool isOnline = false.obs;
  Version? installedVersion;
  Version? latestVersion;
  String? installedFileName;
  String? latestFileName;
  
  checkOnlineStatus() async {
    try {
      var response = await http.get(Uri.parse("http://clients3.google.com/generate_204"));
      if (response.statusCode == 204) {
        isOnline.value = true;
        checkForAppUpdate();
      } else {
        isOnline.value = false;
      }
    } catch(e) {
      isOnline.value = false;
    }
  }

  checkForAppUpdate() async { 
    try {
      var newVersion = NewVersionPlus(
        // iOSId: '', 
        // iOSAppStoreCountry: 'JP',
        androidId: 'com.trend74x.sangeet', 
        androidPlayStoreCountry: 'NP'
      );
      var version = await newVersion.getVersionStatus();
      installedFileName = version!.localVersion;
      latestFileName = version.storeVersion;
      bool updateAvailable = await isUpdateAvailableCheck();
      if(updateAvailable) {
        return showUpdateDialog();
      }
    } catch(e) {
      log('Error on update');
    }
  }

  isUpdateAvailableCheck() async {
    installedVersion = Version.parse(installedFileName!);
    latestVersion = Version.parse(latestFileName!);
    if(latestVersion! > installedVersion) {
      log('Update Available => true');
      return true;
    }
    else{
      log('Update Available => false');
      return false;
    }
  }

  showUpdateDialog() {
    return Get.dialog(
      PopScope(
        canPop: false,
        child: CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Text('New Update Available'),
          ),
          content: Text('Please install latest version'),
          actions: [
              CupertinoDialogAction(
                child: Text('Update'),
                onPressed: () async {
                  openStore();
                }
              )
            ]
        ),
      ),
      barrierDismissible: false
    );
  }

  openStore() async {
    return OpenStore.instance.open(
      // appStoreId: '', // AppStore id of your app for iOS
      androidAppBundleId: 'com.trend74x.sangeet', // Android app bundle package name
    );
  }

}