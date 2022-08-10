

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/splash_screen.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case '/Login':
        return MaterialPageRoute(builder: (_) => LoginPage());
      case '/Home':
        return MaterialPageRoute(builder: (_) => HomePage());
      case '/Splash':
        //return MaterialPageRoute(builder: (_) => SplashScreen());

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return MaterialPageRoute(builder: (_) => const Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}