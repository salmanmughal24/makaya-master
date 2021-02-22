import 'dart:convert';

import 'package:device_id/device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:makaya/ViewCart.dart';
import 'package:makaya/signup.dart';
import 'Api/Api.dart';
import 'package:makaya/test.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'User.dart';
import 'ViewFavItems.dart';
import 'main.dart';
import 'login.dart';
import 'amazon/webview.dart';
import 'walmart/WalmartWebView.dart';

class SplashScren extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScren> {
  LoginPage obj;

  @override
  Widget build(BuildContext context) {
 //   Api.getCart();
 //   Api.getFav();

    MyApp.url = "https://www.amazon.com/";
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: /*GridLayout()*/ FirebaseAuth.instance.currentUser==null? LoginPage():GridLayout(),
      title: new Text(
        'Welcome to Makaya',
        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image: Image.asset('assets/images/makaya.png'),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: () => print("Makaya"),
      loaderColor: MyApp.primarycolor,
      loadingText: new Text("Created By ENSORCELL DESIGNS & SOLUTIONS"),
    );
  }

  Future<String> getSession(BuildContext context) async {
    String device_id = await DeviceId.getID;
    String query = MyApp.base_url + "/User/getSession/" + device_id;
    print(query);
    final response = await http.get(query);
    var data = json.decode(response.body);
    print(data["user"]);
    int userid = int.parse(data["user"]["id"]);
    /*MyApp.user = new User(userid.toString(), data["user"]["name"],
        data["user"]["email"], data["user"]["address"]);*/

//return true;

    if (data["success"] == true) {
      // ViewCart.getCart();
      return "Grid";
    } else {
      return "Login";
    }
  }
}
