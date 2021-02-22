import 'package:flutter/material.dart' hide Element;
import '../main.dart';
import '../models/listAttributes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document, Element;



class EbayDataParsing {

  String title;
  String price;
  String type;
  String weight;
  String image;
  String size;
  String color;

  BuildContext context;
  static all_listAttributes item;
  String url = "";
  bool parsedSuccess = false;


  Future<bool> viewProduct(String url,BuildContext context, Map<String, String> dropdownvalue) async
  {
    this.context = context;


    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');

      if (url == null || url == "")
        return false;
      menu = await http.get(url);
      this.url = url;
      var document = parse(menu.body);
      if (parse_page(document,dropdownvalue, "") == -1) {
        return false;
      } else
        return true;
    }
    on Exception catch (e) {
      print("check");
      print(e);
      return false;
    }
    //return menu.body;

  }
  int parse_page(Document document, Map<String, String> dropdownvalue, String type)
  {
    try{
      this.size = dropdownvalue['Size'];
      this.color = "LOL";
      dropdownvalue.forEach((key, value) {
        if(key.contains("Colour")){
          this.color = value;
        }

      });


      //For Image Parsing of Product
       var ebayImage=document.getElementById("icImg");

       if(ebayImage!=null)
         {
          image=ebayImage.attributes["src"];
         }
      // For title parsing of product
       var ebayTitle=document.getElementById("itemTitle");
       if(ebayTitle!=null) {
         var tt=ebayTitle.innerHtml;
         title=tt.substring(tt.lastIndexOf('>')+1,tt.length-1);
         print(title);
       }

       // For price pasing of product
      var ebayPrice=document.getElementById("prcIsum");
       if(ebayPrice!=null) {
      price=ebayPrice.attributes["content"];}


       parsedSuccess = true;

       return 1;

    }
    on Exception catch (e){

      print("error was : ");
      print(e);
      return -1;

    }

  }
  int addTocart(String url) {
    int flag = 0;

    print("teejjj"+this.weight);

    if (!this.weight.contains("ounces")&&!this.weight.contains("pounds"))
      this.weight = "";
    if (this.price.contains("-")) {
      return 3;
    }

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
        this.color,
        this.image,
        "Ebay",
        this.size,
        url);
     // print("hrgjegrhebrhgehrgeh"+temp.size);

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

  }





  void reset() {
    this.title = "";
    this.price = "";
    this.type = "";
    this.weight = "";
    this.image = "";
    this.size = "";
    this.color = "";
  }

  int addTofav(String url) {
    int flag = 0;
    if (!this.weight.contains("ounces")&&!this.weight.contains("pounds"))
      this.weight = "";
    if (this.price.contains("-")) {
      return 3;
    }

    for (int i = 0; i < MyApp.witems.length; i++)
      if (this.image == MyApp.witems[i].image) {
        MyApp. witems[i].quantity++;
        flag = 1;
        return 2;
      }

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
