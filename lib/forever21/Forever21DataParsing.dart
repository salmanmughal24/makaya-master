import '../main.dart';
import '../models/listAttributes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Forever21DataParsing {
  String title;
  String price;
  String type;
  String weight;
  String image;
  String size;
  String color;
  bool parsedSuccess = false;
  String url = "";
  static all_listAttributes item;

  int parsePage(Document document, String type) {
    print('Page parsing is called');
    try {
      //For image
//        var weightTag = document.getElementsByClassName("image-viewer");
//
//        int weightIndex = 0;
//
//        String checkweightclass = "";
//        String checkweightindex = "";
//
//
//
//        for (int i = 0; i < weightTag.length; i++) {
//          checkweightclass = weightTag[i].attributes["src"].trim();
//          // Checking the following class
//          if (checkweightclass != null)
//            if (checkweightclass ==
//                "magnifier-image") {
//              checkweightindex = weightTag[i].text.trim();
//              print('Weight index by name $checkweightindex');
//              if (checkweightindex == "Item Weight") {
//                weightIndex = i + 1;
//                print('Weight index');
//                break;
//              }
//            }
//        }
//
//
//
//
//        var im = document.getElementsByClassName("image-viewer");
//
//        //print('Image is: ${im[1].attributes['src']}');
//        if(im.length>0){
//
//          image = im[0].attributes['src'];
//          print('Srcs is: $image');
//          if(!image.contains("https:") && !image.contains("http:")){
//
//            image = "http:"+image;
//
//          }
//
//        }
      //For title
      print('Title Tag is ${document.getElementsByClassName("pdp__name body-type--deka text-line--normal")}');
      var titleTag = document.getElementsByClassName("pdp__name body-type--deka text-line--normal");
      print('Title is : $titleTag');
      this.title = titleTag[0].text.trim();
      print('T Title is  : ${this.title}');
      //For price
//
//        var pr = document.getElementsByClassName("price-characteristic");
//
//        if(pr.length>0){
//
//          price = pr[0].attributes["content"];
//
//        }
//
//        var we = document.getElementById("specifications");
//
//        if(we!=null){
//
//          var we_sub = we.getElementsByTagName("td");
//          for(int i=0;i<we_sub.length;i++){
//
//            if(we_sub[i].text.contains("Weight")){
//
//              weight =we_sub[i+1].text;
//
//            }
//
//            if(we_sub[i].text.contains("Size")){
//
//              size = we_sub[i+1].text;
//
//            }
//
//
//
//          }
//
//
//        }

      var im = document.getElementsByClassName("product-gallery__img set--w-100");

      if(im.length>0){

        print(im[0].attributes["src"]);
        image = im[0].attributes["src"];

      }



      var pr = document.getElementsByClassName("value price__default  font-weight--bold ");

       if(pr.length>0){

         price = pr[0].text.split(" ").last.replaceFirst("\$", "");

       }

      var cl = document.getElementsByClassName("product-attribute__selected-value form-control-label ");

      if(cl.length>0){
        print(cl[0].innerHtml.toString());

        color = cl[0].text.trim();

      }

      var sz = document.getElementsByClassName("product-attribute__swatch swatch--size swatch--size-large selectable");

      if(sz.length>0){

        print(sz[0].innerHtml.toString());
        size = sz[0].text.trim();

      }

      parsedSuccess = true;
      return 1;
    }on
    Exception catch (e){
      print("error was : ");
      print(e);
      return -1;
    }
  }

  Future<bool> viewProduct(String url) async {
    print('url is :$url');
    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');
      if (url == null || url == "")
        return false;
      menu = await http.get(url);
      this.url = url;
      print('response is: ${menu.body}');
      var document = parse(menu.body);
      print('response is document: $document');
      if(parsePage(document, "")==-1){
        return false;
      }else
        return true;
    }
    on Exception catch (e) {
      print("check");
      print('Page parsing is called checked exception');
      print(e);
      return false;
    }
  }

  int addToCart(String url) {
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
        color,
        this.image,
        "Forever-21",
        this.size,
        url);
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
  }

  int addToFav(String url) {
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
      // fwvp.evalJavascript("jQuery('#preloader').remove();");
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
