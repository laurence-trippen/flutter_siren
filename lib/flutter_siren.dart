library flutter_siren;

import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_siren/services/apple_app_store.dart';
import 'package:flutter_siren/services/google_play_store.dart';

class Siren {
  String storeVersion;
  String storeUrl;

  Future<String> _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> _getPackage() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> _getStoreVersion() async {
    String packageName = await _getPackage();

    if (Platform.isIOS) {
      final applicationDetails = await AppleAppStore.getStoreDetails(from: packageName);
      this.storeUrl = 'https://apps.apple.com/app/id${applicationDetails.trackId.toString()}?mt=8';
      this.storeVersion = applicationDetails.version;
    }

    if (Platform.isAndroid) {
      this.storeUrl = 'https://play.google.com/store/apps/details?id=$packageName';
      this.storeVersion = await GooglePlayStore.getLatestVersion(from: packageName);
    }

    return this.storeVersion;
  }

  void _openStoreUrl(BuildContext context) async {
    try {
      if (await canLaunch(this.storeUrl)) {
        await launch(this.storeUrl, forceSafariVC: false);
      }
      
      Navigator.of(context).pop();
    }
    on PlatformException {
      Navigator.of(context).pop();
    }
  }

  Future<bool> updateIsAvailable() async {
    String currentVersion = await _getVersion();
    String newVersion = await _getStoreVersion();

    return currentVersion != newVersion;
  }

  Future<void> promptUpdate(BuildContext context, {
    String title = 'Update Available',
    String message = 'There is an updated version available on the App Store. Would you like to upgrade?',
    String buttonUpgradeText = 'Upgrade',
    String buttonCancelText = 'Cancel',
    bool forceUpgrade = false
  }) async {
    final buttons = <Widget>[];

    if (!forceUpgrade) {
      buttons.add(FlatButton(
        child: Text(buttonCancelText),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ));
    }

    buttons.add(FlatButton(
      child: Text(buttonUpgradeText),
      onPressed: () => _openStoreUrl(context),
    ));

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FutureBuilder<bool>(
          future: updateIsAvailable(),
          builder: (context, AsyncSnapshot<bool> snapshot){ 
            if (snapshot.hasData) {
              return AlertDialog(
                title: Text(title),
                content: Text(message),
                actions: buttons,
              );
            }

            return Container();
          }
        );
      },
    );
  }
}