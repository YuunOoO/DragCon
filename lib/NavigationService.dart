import 'package:dragcon/Pages/homepage.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) async {
    return navigatorKey.currentState?.pushNamed(routeName);
  }

  Future<void> LogOut() async {
    navigateTo('homepage');
  }
}
