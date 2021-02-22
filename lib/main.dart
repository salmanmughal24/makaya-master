import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:makaya/hm/hmParsing.dart';
import 'package:makaya/macys/macysParsing.dart';
import 'package:makaya/shein/sheinParsing.dart';
import 'package:makaya/zaful/zafulParsing.dart';
import 'package:makaya/zara/zaraParsing.dart';
import 'AliExpress/aliExpressParsing.dart';
import 'SplashScreen.dart';
import 'User.dart';
import 'ebay/EbayDataParsing.dart';
import 'fashionnova/FashionNovaDataParsing.dart';
import 'forever21/Forever21DataParsing.dart';
import 'homedepot/homeDepotParsing.dart';
import 'lowes/lowesParsing.dart';
import 'models/listAttributes.dart';
import 'nointernet.dart';
import 'amazon/parsing.dart';
import 'vipoutlet/vipOutletParsing.dart';
import 'walmart/WalmartDataParsing.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyApp();
  bool check = await MyApp.checkInternet();

  if (check) {
    runApp(
    Phoenix(
    child:
          MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(),
              home: SplashScren()
          )));



  } else {
    runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: NoInternet(null)));
  }
}

class MyApp {
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }

  static String base_url = "http://ensorcelldns.com/new_api";

  //static String base_url = "http://192.168.1.7/makaya_api";
  static String url = "";
  static User user;

  static AmazonDataParsing obj = new AmazonDataParsing();
  static AliExpressDataParsing objAliExpressPrsing =
      new AliExpressDataParsing();
  static WalmartDataParsing walmart_obj = new WalmartDataParsing();
  static EbayDataParsing ebay_obj = new EbayDataParsing();
  static Forever21DataParsing objForever21Prsing = new Forever21DataParsing();
  static HMDataParsing objHMPrsing = new HMDataParsing();
  static LowesDataParsing objLowesPrsing = new LowesDataParsing();
  static VipOutletDataParsing objVipOutletPrsing = new VipOutletDataParsing();
  static HomeDepotDataParsing objHomeDepotPrsing = new HomeDepotDataParsing();
  static SheinDataParsing objSheinPrsing = new SheinDataParsing();
  static ZaraDataParsing objZaraPrsing = new ZaraDataParsing();
  static ZafulDataParsing objZafulPrsing = new ZafulDataParsing();
  static MacysDataParsing objMacysPrsing = new MacysDataParsing();
  static FashionNovaDataParsing objFashionNovaPrsing =
      new FashionNovaDataParsing();
  static Color primarycolor = Color.fromRGBO(43, 87, 126, 1);
  static List<all_listAttributes> aitems = new List();
  static List<all_listAttributes> witems = new List();

  static bool enteredProductPage = false;

  static bool _showTitle(String url) {
    bool _nav_visibilty = false;

    int count = 0;
    for (int i = 0; i < MyApp.url.length; i++) {
      if (MyApp.url[i] == "/") count++;
    }

    print(count.toString() + " -- hekiil");
    if (count > 7) {
      print(count.toString() + " Not Working");
      _nav_visibilty = true;
    } else {
      print(MyApp.url.lastIndexOf("/").toString() + " Working");
      _nav_visibilty = false;
    }

    return _nav_visibilty;
  }

  static void showTitle(String url) {}

  static showProgressDialog(BuildContext context, String title) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  Flexible(
                      flex: 8,
                      child: Text(
                        title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
