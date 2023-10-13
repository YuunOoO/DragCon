import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) async {
    return navigatorKey.currentState?.pushNamed(routeName);
  }

  Future<void> logOut() async {
    navigateTo('homepage');
  }
}
