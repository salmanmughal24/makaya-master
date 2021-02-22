import 'dart:io';

import '../main.dart';
import '../models/listAttributes.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dd;



class MacysDataParsing {

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

  Future<bool> viewProduct(String url) async
  {
    print('url is :$url');
    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');

      if (url == null || url == "")
        return false;


      var isRedirect = true;
      while (isRedirect) {
        final client = http.Client();
        print(url);
        final request = http.Request('GET', Uri.parse(url.contains("https")?"":"https://www.macys.com"+url))
          ..followRedirects = false
          ..headers['cookie'] = 'security=true';

        print(url);
        print(request.headers);
        final response = await client.send(request);

        if (response.statusCode == HttpStatus.movedTemporarily) {
          isRedirect = response.isRedirect;
          url = response.headers['location'];
          print(url);
          // final receivedCookies = response.headers['set-cookie'];
        } else if (response.statusCode == HttpStatus.ok) {
          menu =response.stream;
          print(menu);
          //    menu = await client.send(request);
          this.url = url;
          print('response is: ${menu.body}');
          var document = parse(menu.body);
          print('response is document: $document');
          if(parse_page(document, "")==-1){

            return false;

          }else
            return true;

        }
      }


    }
    on Exception catch (e) {
      print("check");
      print('Page parsing is called checked exception');
      print(e);
      return false;
    }
    //return menu.body;

  }




  int parse_page(dd.Document document, String type) {
    //get image
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
       var im = document.getElementsByClassName("zoomer-image");

       //print('Image is: ${im[1].attributes['src']}');
       if(im.length>0) {
         image = im[0].attributes['src'];
         print('Srcs is: $image');

       }
    //For title
        print('Title Tag is ${document.getElementsByClassName("p-brand-title bold")}');
        var titleTag = document.getElementsByClassName("p-brand-title bold");

        print('Title is : $titleTag');

        this.title = titleTag[0].innerHtml;
        print('T Title is  : ${this.title}');
        //For price
//
       var pr = document.getElementsByClassName("price");

       if(pr.length>0){

         price = pr[0].text;
         print(price);

       }
       
       var cl = document.getElementsByClassName("selected-color");
       if(cl.length>0){
         color = cl.first.innerHtml;
       }
       
       
/*
      List<dd.Element> we = document.getElementsByClassName("row product-properties__item");
       we.forEach((element) {
         print(element.innerHtml);
          if(element.children[0].innerHtml=="Weight:"){

            print(element.children.toString());
            weight = element.children[1].innerHtml;
            print("koka"+weight);

          }


       });

      List<dd.Element> sss = document.getElementsByClassName("row product-properties__item");
      sss.forEach((element) {
        print(element.innerHtml);
        if(element.children[0].innerHtml=="Dimensions:"){

          print(element.children.toString());
          dimensions = element.children[1].innerHtml;
          print("koka"+weight);

        }


      });*/



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


        parsedSuccess = true;
        return 1;

    }on Exception catch (e){

      print("error was : ");
      print(e);
      return -1;

    }


  }


  int addTocart(String url) {
    int flag = 0;

    print("teejjj"+this.weight);

 /*   if (!this.weight.contains("ounces")&&!this.weight.contains("pounds"))
      this.weight = "";
  *//*  if (this.price.contains("-")) {
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
        "Vip Outlet",
        this.size,
        url
    ,
    dimensions:this.dimensions
    );
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
