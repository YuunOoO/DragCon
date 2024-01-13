import 'package:dragcon/navigation_service.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Localauth {
  static final _auth = LocalAuthentication();
  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
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
    } on PlatformException {
      NavigationService nav = NavigationService();
      nav.logOut();
      return false;
    }
  }
}