import 'package:flutter/material.dart';
import 'package:makaya/main.dart';
import '../models/listAttributes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

import 'webview.dart';

class AmazonDataParsing {
  String title;
  String price;
  String type;
  String weight;
  String image;
  String size;
  String color;

  static all_listAttributes item;
  String url = "";
  bool parsedSuccess = false;

  Future<bool> viewProduct(String url) async {
    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');

      if (url == null || url == "") return false;

      menu = await http.get(url);

      this.url = url;

      //String s = ;
      print(
          'Parsing body is: ${await http.get(url).then((value) => value.body)}');
      var document = parse(menu.body);
      print('Parsing body is document: $document');
      if (parsingCellPhones(document, "") == -1) {
        return false;
      } else
        return true;
      /* var getCatogory = document.getElementsByClassName("a-link-normal a-color-tertiary");

      if(getCatogory.length == 0)
        {
          return false;
        }
      print(getCatogory[0].text);
      String check = getCatogory[0].text;
      check = check.trim();
      if (check == "Books")
        parsingbooks(document);
      if (check != "Books") {
        if(parsingCellPhones(document, check)==-1){
          return false;
        }
      }
      if (check == "Clothing, Shoes & Jewelry") {
        print("Clothing, Shoes & Jewelry ::>  ");
      }
      return true;*/
    } on Exception catch (e) {
      print("check");
      print(e);
      return false;
    }
    //return menu.body;
  }

  void parsingbooks(Document document) {
    var imageTag = document.getElementById("imgBlkFront");
    var src = imageTag.attributes;
    String image = src["data-a-dynamic-image"];
    image = image.substring(image.indexOf("\"", 0) + 1,
        image.indexOf("\"", image.indexOf("\"", 0) + 1));
    //get price
    var priceTag = document.getElementsByClassName("a-color-price");
    print(priceTag.elementAt(1).text);
    print('see data');
  }

  int parsingCellPhones(Document document, String type) {
    //get image
    try {
      // Tag for the image of the product loaded using ID
      var imageTag = document.getElementById("landingImage");

      if (imageTag != null) {
        var src = imageTag.attributes;
        // Tag for the attributtes of the product

        String image = src["data-a-dynamic-image"];

        // Path for the image and removing the strings
        this.image = image.substring(image.indexOf("\"", 0) + 1,
            image.indexOf("\"", image.indexOf("\"", 0) + 1));

        print(this.image);

        //Get price using the class defined in the product page

        var priceTag = document.getElementsByClassName("a-color-price");
        print(priceTag[0].text);

        // Removing whitespaces
        this.price = priceTag[0].text.trim();

        if (this.price.contains("Currently unavailable.") ||
            this.price.contains("In Stock.")) {
          return -1;
        }

        //Get tittle of the product by ID

        var titleTag = document.getElementById("productTitle");

        print(titleTag.text.trim());

        this.title = titleTag.text.trim();

        //Get weight by the class of the product
        var weightTag = document.getElementsByClassName("a-size-base");

        int weightIndex = 0;

        String checkweightclass = "";
        String checkweightindex = "";

        //Check the array and get the class
        for (int i = 0; i < weightTag.length; i++) {
          checkweightclass = weightTag[i].attributes["class"].trim();
          // Checking the following class
          if (checkweightclass != null) if (checkweightclass ==
              "a-color-secondary a-size-base prodDetSectionEntry") {
            checkweightindex = weightTag[i].text.trim();
            if (checkweightindex == "Item Weight") {
              weightIndex = i + 1;
              break;
            }
          }
        }

        var sizeTag = document.getElementsByClassName("a-dropdown-prompt");

        if (sizeTag.length > 0) {
          size = sizeTag[0].text.trim();

          if (size.trim() == "1" || size.trim() == "Top Reviews") {
            size = "";
          }
        }

        var colorTag = document.getElementById("variation_color_name");

        if (colorTag != null) {
          String test = colorTag.text.replaceAll("\n", "");
          test = test.replaceAll(" ", "");
          test = test.replaceAll("\t", "");
          test = test.replaceAll("Color:", "");

          if (test.contains("\$"))
            color = test.substring(0, test.indexOf("\$"));
          else
            color = test;
          print(color);
        } else {
          color = "";
        }

        this.weight = weightTag[weightIndex].text.trim();

        var sizess = document.getElementById("variation_size_name");

        if (sizess != null) {
          size =
              "" + sizess.text.trim().replaceAll("\n", "").replaceAll(" ", "");

          int indexx = size.indexOf("SizeChart");

          if (indexx != -1) size = size.substring(0, indexx);
          size = size.replaceAll("Size:", "");

          if (size.length > 25) {
            var temp = sizess.getElementsByClassName("a-dropdown-prompt");

            for (int i = 0; i < temp.length; i++) {
              size = temp[i].text;

              //print(temp1);

            }
          }

          print("bundle : ");
          print(size);
        }

        var styles = document.getElementById("variation_style_name");

        if (styles != null && color == "") {
          print("colorssssss : ");
          print(styles.text);
          color = styles.text.trim().replaceAll("\n", "").replaceAll(" ", "");
          if (color.indexOf("\t") != -1) {
            color = color.substring(0, color.indexOf("\t"));
          }

          print("color : ");
          print(color);
        }

        parsedSuccess = true;

        return 1;
      } else {
        var imageTag = document.getElementById("imgBlkFront");

        var src = imageTag.attributes;

        String image = src["data-a-dynamic-image"];

        image = image.substring(image.indexOf("\"", 0) + 1,
            image.indexOf("\"", image.indexOf("\"", 0) + 1));

        print(image);

        this.image = image;

        //get price
        var priceTag = document.getElementsByClassName("a-color-price");
        print(priceTag.elementAt(1).text);

        this.price = priceTag.elementAt(1).text;

        //this.price = priceTag[0].text.trim();

        if (this.price.contains("Currently unavailable.")) {
          return -1;
        }
        //get title

        var titleTag = document.getElementById("productTitle");

        print(titleTag.text.trim());

        this.title = titleTag.text.trim();

        //get Weight

        var weightTag = document.getElementsByClassName("a-size-base");

        int weightIndex = 0;

        String checkweightclass = "";
        String checkweightindex = "";
        for (int i = 0; i < weightTag.length; i++) {
          checkweightclass = weightTag[i].attributes["class"].trim();
          if (checkweightclass != null) if (checkweightclass ==
              "a-color-secondary a-size-base prodDetSectionEntry") {
            checkweightindex = weightTag[i].text.trim();
            if (checkweightindex == "Item Weight") {
              weightIndex = i + 1;
              break;
            }
          }
        }

        var sizeTag = document.getElementsByClassName("a-dropdown-prompt");

        if (sizeTag.length > 0) {
          size = sizeTag[0].text.trim();

          if (size.trim() == "1" || size.trim() == "Top Reviews") {
            size = "";
          }
        }

        var colorTag = document.getElementById("variation_color_name");

        if (colorTag != null) {
          String test = colorTag.text.replaceAll("\n", "");
          test = test.replaceAll(" ", "");
          test = test.replaceAll("\t", "");
          test = test.replaceAll("Color:", "");

          if (test.contains("\$"))
            color = test.substring(0, test.indexOf("\$"));
          else
            color = test;
          print(color);
        } else {
          color = "";
        }

        this.weight = weightTag[weightIndex].text.trim();

        var sizess = document.getElementById("a-autoid-13-announce");

        if (sizess != null) {
          size = "" + sizess.text.trim();

          print("bundle : ");
          print(size);
        }

        var styles = document.getElementById("variation_style_name");

        if (styles != null) {
          color = styles.text.trim();

          print("color : ");
          print(color);
        }

        parsedSuccess = true;

        return 1;
      }
    } on Exception catch (e) {
      print("error was : ");
      print(e);
      return -1;
    }
  }

  int addTocart(String url) {
    int flag = 0;

    print("teejjj" + this.weight);

    if (!this.weight.contains("ounces") && !this.weight.contains("pounds"))
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

    MyApp.aitems.add(new all_listAttributes(this.title, this.price, this.type,
        1, this.weight, color, this.image, "Amazon", this.size, url));

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

    MyApp.witems.add(new all_listAttributes(this.title, this.price, this.type,
        1, this.weight, this.color, this.image, "Amazon", this.size, url));

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
