import 'package:device_id/device_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/listAttributes.dart';
import 'ViewCart.dart';
import 'login.dart';
import 'main.dart';
import 'amazon/parsing.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ViewCart.dart';
import 'test.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

import 'amazon/webview.dart';
class CheckOut extends StatefulWidget
{
  CheckOutItems createState() => new CheckOutItems();
}
class CheckOutItems extends State<CheckOut> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  void _showNotification() async {
    await _demoNotification();
    MyApp.aitems.clear();
  }
  Future<void> _demoNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0, 'Hello, buddy',
        'We have recieved your order.ThankYou for using Makaya', platformChannelSpecifics,
        payload: 'test oayload');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializationSettingsAndroid =
    new AndroidInitializationSettings('makaya');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new GridLayout()));
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GridLayout()));
              },
            )
          ],
        ));
  }


    double calculateTotal(){

    double total=0.0;
    String str="";

    for(int i=0;i<MyApp.aitems.length;i++){

      str = MyApp.aitems[i].price;
      print(str);
      total += (double.parse(str.substring(1).replaceAll(",", ""))) * MyApp.aitems[i].quantity ;
      print(total.toString()+" - fucking fuckking");
    }

    return total;


  }
  Future <bool> createOrder (String str) async
  {
    String device_id=await DeviceId.getID;

    print(str);
    print(MyApp.user.id);
    print(calculateTotal().toString());
    print(device_id);

  final response = await http.post(
        MyApp.base_url+"/User/createOrder",
        body: {
          /**/
          "data":str,
          "user_id":MyApp.user.id,
          "totalprice":calculateTotal().toString(),
          "device_id":device_id

        });


    print(response.body);
    var data = json.encode(response.body);

    print(data+"OYYYYYYY"+MyApp.user.id+calculateTotal().toString());
    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut()));

    return true;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final totalAmount = Text(
        'Total Amount= \$ ' + calculateTotal().toString(),
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    final shippingamount = Text(
        'Shippment Amount= 50',
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    final orderButton = new ButtonTheme(
      minWidth: 330.0,
      padding: new EdgeInsets.all(0.0),
      child: RaisedButton(
        child: Text("Confirm Order",
          style: TextStyle(color: Colors.white, fontSize: 20.0),),
        color: MyApp.primarycolor,


        onPressed: () {
          String str = "";
          str = jsonEncode(
              MyApp.aitems.map((f) => f.toJsonAtt()).toList());
          print(str);

          Alert(
            context: context,
            type: AlertType.success,
            title: "Confirm Order",
            buttons: [
              DialogButton(
                child: Text(
                  "YES",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  if (MyApp.user == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  else {
                    String str = "";
                    str = jsonEncode(MyApp.aitems.map((f) =>
                        f.toJsonAtt()).toList());
                    print(str);
                    print(calculateTotal().toString());
                    createOrder(str);
                    _showNotification();

                    Navigator.pop(context);
                  }
                },
                color: Color.fromRGBO(0, 179, 134, 1.0),
              ),
              DialogButton(
                child: Text(
                  "NO",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(116, 116, 191, 1.0),
                  Color.fromRGBO(52, 138, 199, 1.0)
                ]),
              )
            ],
          ).show();
        },
      ),
    );
    if (MyApp.aitems.length == 0) {
      return Scaffold(
        appBar: AppBar(

          iconTheme: new IconThemeData(color: Colors.white),

          backgroundColor: MyApp.primarycolor,

          title: Container(

            height:80,
            width: 80,

            child: Image.asset('assets/images/makaya.png', fit: BoxFit.contain,),

          ),
          actions: <Widget>[

            FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text("Checkout"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),

          ],
        ),

        body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new ButtonTheme(
                minWidth: 400.0,
                padding: new EdgeInsets.all(0.0),
                child: FlatButton(
                  color: Colors.red,
                  child: Text(
                    "No Items available for checkout.Want to  shop?? ",
                    style: TextStyle(
                        color: Colors.blueGrey[900], fontSize: 15.0),),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            WebViewAmazon("http://www.amazon.com/")));
                  },

                ),
              )
            ]


        ),


      );
    }
    else {
      return Scaffold(
        appBar: AppBar(

          iconTheme: new IconThemeData(color: Colors.white),

          backgroundColor: MyApp.primarycolor,

          title: Container(

            height:80,
            width: 80,

            child: Image.asset('assets/images/makaya.png', fit: BoxFit.contain,),

          ),
          actions: <Widget>[

            FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text("Checkout"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),

          ],
        ),

        body: SingleChildScrollView(child:
        Column(children: <Widget>[
          Container(child: DataTable(

            columns: <DataColumn>[


              DataColumn(

                label: Text('Title', style: TextStyle(color: Colors.black87,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Quantity', style: TextStyle(color: Colors.black87,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold)),
              ),
              DataColumn(
                label: Text('Price', style: TextStyle(color: Colors.black87,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold)),

              ),


            ],
            rows: MyApp.aitems
                .map(
                  (itemRow) =>
                  DataRow(
                    cells: [

                      DataCell(
                        Text(itemRow.title.toString().substring(0, 20)),


                      ),
                      DataCell(
                        Text(itemRow.quantity.toString()),
                      ),
                      DataCell(
                        Text(itemRow.price.toString()),),
                    ],
                  ),
            )
                .toList(),
          ),
          ),
          SizedBox(height: 10.0,),
          shippingamount,
          SizedBox(height: 10.0,),
          totalAmount,
          SizedBox(height: 10.0,),
          orderButton,
        ],
        ),

        ),


      );
    }
  }


}