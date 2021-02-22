import 'package:universal_html/html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../main.dart';
import '../models/listAttributes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dd;

class LowesDataParsing {
  String title;
  String price;
  String type;
  String weight;
  String image;
  String size;
  String color;
  String dimensions;

  static all_listAttributes item;
  String url = "";
  bool parsedSuccess = false;

  Future<bool> viewProduct(String url, WebViewController web) async {
    print('url is :$url');
    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');

      if (url == null || url == "") return false;
      http.Response menu = await http.get(url);
      /*  menu.
      this.url = url;*/
      print('response is: ${menu.body}');
      var document = parse(menu.body);
      print('response is document: $document');
      if (parse_page(web, "", document) == -1) {
        return false;
      } else
        return true;
    } on Exception catch (e) {
      print("check");
      print('Page parsing is called checked exception');
      print(e);
      return false;
    }
    //return menu.body;
  }

  Future<int> parse_page(
      WebViewController web, String type, dd.Document document) async {
    //get image
    print('Page parsing is called');
    try {

      var im = await web.evaluateJavascript(
          "window.document.getElementsByClassName(\"styles__ListImage-sc-4c9re0-2 jTNuZM\")[0].attributes[\"src\"].value;");
      if (im != null) {
        image = im.replaceAll(" ", "").replaceAll("\"", "");
      }
      print("Image" + image);

      String tt = await web.currentUrl();

      if (tt != null) {
        title = tt.split("/")[4].replaceAll("-", " ");
      }
      print("Title" + title);

      var pp = await web.evaluateJavascript(
          "window.document.getElementsByClassName(\"sc-fzoant hXtGXC\")[0].innerHTML;");
      if (pp != null) {
        price = pp
            .trim()
            .replaceAll("\$", "")
            .replaceAll(" ", "")
            .replaceAll("\"", "");
      }
      print("Price" + price);

      parsedSuccess = true;
      return 1;
    } on Exception catch (e) {
      print("error was : ");
      print(e);
      return -1;
    }
  }

  int addTocart(String url) {
    int flag = 0;

    //   print("teejjj"+this.weight);

    /*   if (!this.weight.contains("ounces")&&!this.weight.contains("pounds"))
      this.weight = "";
  */ /*  if (this.price.contains("-")) {
      return 3;
    }
*/
    for (int i = 0; i < MyApp.aitems.length; i++)
      if (this.image == MyApp.aitems[i].image) {
        MyApp.aitems[i].quantity++;
        flag = 1;
        return 2;
      }

    all_listAttributes temp = new all_listAttributes(
        this.title,
        this.price,
        this.type,
        1,
        this.weight,
        color,
        this.image,
        "Lowes",
        this.size,
        url,
        dimensions: this.dimensions);
    MyApp.aitems.add(temp);

    if (flag == 0) {
      print("see data");
      //fwvp.evalJavascript("jQuery('#preloader').remove();");
      return 1;
      //fwvp.reloadUrl(url);
      //fwvp.dispose();

    } else {
      return 0;
    }

/*
    this.title ="";
    this.price = "";
    this.type="";
    this.weight="";
    this.image="";

    parsedSuccess= false;*/
  }

  void reset() {
    this.title = "";
    this.price = "";
    this.type = "";
    this.weight = "";
    this.image = "";
    this.dimensions = "";
  }

  int addTofav(String url) {
    int flag = 0;
    if (!this.weight.contains("ounces") && !this.weight.contains("pounds"))
      this.weight = "";
    if (this.price.contains("-")) {
      return 3;
    }

    for (int i = 0; i < MyApp.witems.length; i++)
      if (this.image == MyApp.witems[i].image) {
        MyApp.witems[i].quantity++;
        flag = 1;
        return 2;
      }

    /*MyApp. witems.add(new listAttributes(
        this.title,
        this.price,
        this.type,
        1,
        this.weight,
        this.color,
        this.image,
        "Walmart",
        this.size,
        url));*/

    if (flag == 0) {
      print("see data");
      //fwvp.evalJavascript("jQuery('#preloader').remove();");
      return 1;
      //fwvp.reloadUrl(url);
      //fwvp.dispose();

    } else {
      return 0;
    }
  }

  String getImage() {
    return image;
  }
}
