

import 'dart:convert';

import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../User.dart';
import '../models/listAttributes.dart';
import '../main.dart';

class Api {

  static Future <bool> addFav () async
  {
    String device_id=await DeviceId.getID;
    String str="";
    str +=jsonEncode(MyApp.witems.map((f)=>f.toJsonAttr()).toList());
    print(str);

    final response = await http.post(
        MyApp.base_url+"/fav.php",
        body: {
          "data":str,
          "deviceId":device_id
        });

    print(response.body);
    var data = json.encode(response.body);

    print(data);


    return true;

  }

  static Future <bool> login (context,String email,String pass) async
  {

    final response = await http.post(
        MyApp.base_url+"/User/loginUser",
        body: {
          "email": email,
          "password": pass,
        });
    var data = json.decode(response.body);

    print(data["user"]);

    if (data["success"] != null) {
      MyApp.user = new User(
          data["user"]["id"], data["user"]["name"], data["user"]["email"],
          data["user"]["address"]);
      session(data["user"]["id"]);
      Navigator.pop(context);
      Navigator.pop(context);

      return true;
    }
    else {

      Navigator.pop(context);

      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "Name or Password is incorrect.",
        buttons: [
          DialogButton(
            child: Text(
              "BACK",
              style: TextStyle(color: Color(0XFF2B567E), fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
      return false;
    }
    /* Map<String, dynamic> user = jsonDecode(data);

            print('Howdy, ${user['name']}!');
            print('We sent the verification link to ${user['email']}.');*/



  }


  static  Future <List> session (String userid) async
  {
    String device_id=await DeviceId.getID;
    var now = new DateTime.now();
    final response = await http.post(
        MyApp.base_url+"/User/createSession",
        body: {
          "device_id":device_id ,
          "userid":userid,
          "date": new DateFormat("dd-MM-yyyy").format(now),
        });
    var data = json.decode(response.body);

    print(data["success"]);

    if(data["success"]!=null)
    {

    }
    else{}

  }
  static  Future <List> signUp (context,String name,String address,String email,String password,String retype) async
  {

    if(password != retype){

      Navigator.pop(context);
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "Password And ReType Do Not Match!!!",
        buttons: [
          DialogButton(
            child: Text(
              "BACK",
              style: TextStyle(color: Color(0XFF2B567E), fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();

      return [];
    }

    final response = await http.post(
        MyApp.base_url+"/User/createUser",
        body: {
          "name": name,
          "address": address,
          "email": email,
          "password": password,
        });
    var data = json.decode(response.body);
    print(data);
    if(data["success"]!=null)
    {
      Navigator.pop(context);
      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Account Created you can Login now!!",
        buttons: [
          DialogButton(
            child: Text(
              "BACK",
              style: TextStyle(color: Color(0XFF2B567E), fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();

    }
    else
    {
      Navigator.pop(context);
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: data["error"],
        buttons: [
          DialogButton(
            child: Text(
              "BACK",
              style: TextStyle(color: Color(0XFF2B567E), fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }


  }

  static Future <bool> addCart () async
  {
    String device_id=await DeviceId.getID;
    String str="";
    str +=jsonEncode(MyApp.aitems.map((f)=>f.toJsonAttr()).toList());
    print('Str is : $str');

    final response = await http.post(
        MyApp.base_url+"/cart.php",
        body: {
          "device_id":device_id,
          "string":str,
          
        });

    print(response.body);
    var data = json.encode(response.body);

    print(' data is : $data');

    return true;

  }

  static  Future<List<all_listAttributes>> getFav() async
  {
    String device_id=await DeviceId.getID;

    print(MyApp.base_url+"/fav.php"+device_id);

    var favs=await http.get(MyApp.base_url+"/fav.php"+device_id);
    var jsonData=json.decode(favs.body);

    print(jsonData);

    List<all_listAttributes> favor = List();

    if(jsonData["success"]!=null)
      for(var m in jsonData["success"])
      {
        all_listAttributes item=new all_listAttributes(m["name"],m["price"],m["type"],int.parse(m["quantity"]),m["wegiht"],m["color"],m["image"],m["merchant"],m["size"],m["url"]);
        favor.add(item);
        print(m["name"]);

      }
    MyApp.witems = favor;
    return MyApp.witems;
  }

  static  Future<bool> deleteItem(int index) async {
    String device_id=await DeviceId.getID;
    final response = await http.post(
        MyApp.base_url+"/User/deleteFavItem",
        body: {
          "name":MyApp.witems[index].title,
          "deviceId":device_id
        });  // make DELETE request
    int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
    return true;
  }

  static  Future<List<all_listAttributes >> getCart() async
  {
    String device_id=await DeviceId.getID;

    var carts=await http.get(MyApp.base_url+"/cart.php?"+device_id);
    var jsonData=json.decode(carts.body);
    print(jsonData);

    List<all_listAttributes > cart = List();

    if(jsonData["success"]!=null)
      for(var m in jsonData["success"])
      {
        all_listAttributes  item=new all_listAttributes (m["name"],m["price"],m["type"],int.parse(m["quantity"]),m["weight"],m["color"],m["image"],m["merchant"],m["size"],m["url"]);
        cart.add(item);
        print(m["name"]);

      }
    MyApp.aitems = cart;
    return MyApp.aitems;
  }
  static Future<bool> deleteCartItem(int index) async {
    String device_id=await DeviceId.getID;
    final response = await http.post(
        MyApp.base_url+"/User/deleteCartItem",
        body: {
          "name":MyApp.aitems[index].title,
          "deviceId":device_id
        });  // make DELETE request
    int statusCode = response.statusCode;
    print(statusCode);
    return true;
  }



}