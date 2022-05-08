import 'package:dragcon/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'NavigationService.dart';
import 'Pages/adminpage.dart';

class localauth {
  static final _auth = LocalAuthentication();
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
      return <BiometricType>[];
    }
  }

  static Future<bool> authenticate() async {
    _auth.getAvailableBiometrics();
    try {
      return await _auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      NavigationService nav = new NavigationService();
      nav.LogOut();
      return false;
    }
  }
}
