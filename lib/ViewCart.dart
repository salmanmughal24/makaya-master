import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Api/Api.dart';
import 'Shipment.dart';
import 'checkout.dart';
import 'models/listAttributes.dart';
import 'main.dart';
import 'amazon/parsing.dart';
import 'amazon/webview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:device_id/device_id.dart';

class ViewCartItems extends StatefulWidget {
  @override
  ViewCart createState() => new ViewCart();
}

class ViewCart extends State<ViewCartItems> {
  void add(index) {
    setState(() {
      MyApp.aitems[index].quantity++;
    });
  }

  void minus(index) {
    setState(() {
      if (MyApp.aitems[index].quantity != 1) {
        MyApp.aitems[index].quantity--;
      }
    });
  }

  void remove(index) {
    setState(() {
      MyApp.aitems.removeAt(index);
    });
  }

  double calculateTotal() {
    double total = 0.0;
    String str = "";

    for (int i = 0; i < MyApp.aitems.length; i++) {
      str = MyApp.aitems[i].price;
      print(str);
      total += (double.parse(str.substring(1).replaceAll(",", ""))) *
          MyApp.aitems[i].quantity;
      print(total.toString() + " - fucking fuckking");
    }

    return total;
  }

  Widget myDetailsContainer1(int i) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 0.0),
          child: Container(
              child: Row(
            //        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Container(
                width: 200.0,
                height: 200.0,
                margin: EdgeInsets.only(right: 50, top: 15),
                decoration: new BoxDecoration(
                  color: const Color(0xff7c94b6),
                  image: new DecorationImage(
                    image: new NetworkImage(MyApp.aitems[i].image),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(100.0)),
                  border: new Border.all(
                    color: MyApp.primarycolor,
                    width: 4.0,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                      width: 450,
                      margin: EdgeInsets.only(left: 0.0),
                      child: Text(
                        getNewLineString(MyApp.aitems[i].title.toString()) +
                            "....",
                        maxLines: 10,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.normal),
                      )),
                ],
              ),
            ],
          )),
        ),
        SizedBox(height: 40.0),
        Container(
          width: 300.0,
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: 15),
                height: 150,
                width: 100,
                // color:MyApp.primarycolor,

                decoration: BoxDecoration(
                  color: MyApp.primarycolor,
                  border: Border(
                      left: BorderSide.none,
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      right: BorderSide(
                          color: MyApp.primarycolor, style: BorderStyle.solid)),
                ),
                child: IconButton(
                    iconSize: 40,
                    icon: new Icon(
                      FontAwesomeIcons.minus,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      minus(i);
                    }),
              ),
              Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    MyApp.aitems[i].quantity.toString(),
                    style: TextStyle(
                        color: Color(0XFF2B567E),
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold),
                  )),
              Container(
                padding: EdgeInsets.only(left: 15),
                height: 150,
                width: 100,
                // color: MyApp.primarycolor,
                decoration: BoxDecoration(
                  color: MyApp.primarycolor,
                  border: Border(
                      right: BorderSide.none,
                      top: BorderSide.none,
                      bottom: BorderSide.none,
                      left: BorderSide(
                          color: MyApp.primarycolor, style: BorderStyle.solid)),
                ),
                child: IconButton(
                    iconSize: 40,
                    icon: new Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      add(i);
                    }),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              "Merchant:" + MyApp.aitems[i].merchant.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal),
            )),
        Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              "Price:" + MyApp.aitems[i].price.replaceAll("\$", "USD:"),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal),
            )),
        showData("Weight", MyApp.aitems[i].wegiht),
        showData("Color", MyApp.aitems[i].color),
        showData("Size", MyApp.aitems[i].size),
        showData("Dimensions", MyApp.aitems[i].dimensions),
        Container(
            height: 300.0,
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new ButtonTheme(
                  minWidth: 300.0,
                  height: 105.0,
                  padding: new EdgeInsets.all(0.0),
                  child: RaisedButton(
                    child: Text(
                      "View",
                      style: TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                    color: MyApp.primarycolor,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  WebViewAmazon(MyApp.aitems[i].url)));
                    },
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 80),
                ),
                new Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: MyApp.primarycolor)),
                    child: new ButtonTheme(
                      minWidth: 300.0,
                      height: 105.0,
                      padding: new EdgeInsets.all(0.0),
                      child: RaisedButton(
                        child: Text(
                          "Remove",
                          style: TextStyle(
                              color: MyApp.primarycolor, fontSize: 30.0),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "Remove Item",
                            desc:
                                "Are you you want to remove item from wishlist?",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "Yes",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Api.deleteCartItem(i).then((succes) {
                                    remove(i);
                                    Navigator.pop(context);
                                  });
                                },
                                color: Color.fromRGBO(0, 179, 134, 1.0),
                              ),
                              DialogButton(
                                child: Text(
                                  "No",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
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
                    )),
              ],
            ))
      ],
    );
  }

  String getNewLineString(String readLines) {
    String temp = "";

    if (readLines.length > 30) readLines = readLines.substring(0, 30);

    List<String> tempp = readLines.split(" ");

    for (int i = 0; i < tempp.length; i++) {
      if (i % 3 == 0) {
        temp += "\n";
      }
      temp += tempp[i] + " ";
    }

    return temp;
  }

  Widget showData(String key, String value) {
    // print("lanti -> "+value+" "+key);

    if (value == "" || value == null) {
      return Container(
        height: 0.0,
      );
    } else {
      if (value.contains("Style:")) {
        key = "";
      } else {
        key = key + " : ";
      }

      return Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            key + value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.normal),
          ));
      ;
    }
  }

  List<Widget> createList() {
    List<Widget> w = new List<Widget>();

    for (int i = 0; i < MyApp.aitems.length; i++) {
      w.add(Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: new FittedBox(
            fit: BoxFit.fitWidth,
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: myDetailsContainer1(i),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ));
    }

    return w;
  }

  @override
  Widget build(BuildContext context) {
    int index;
    final checkOutButton = new ButtonTheme(
      minWidth: 330.0,
      padding: new EdgeInsets.all(0.0),
      child: RaisedButton(
        child: Text(
          "Proceed to Shipment",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        color: MyApp.primarycolor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Shipment()));
        },
      ),
    );
    final totalAmount = Text('Total Amount=2800',
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    final totalItems = Text('Total Items=' + MyApp.aitems.length.toString(),
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    if (MyApp.aitems.length == 0) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: MyApp.primarycolor,
          title: Text('Total:' + calculateTotal().toString() + ' USD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text("Cart"),
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
                    "No Items at Cart.Want to add items at cart?",
                    style:
                        TextStyle(color: Colors.blueGrey[900], fontSize: 15.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WebViewAmazon("http://www.amazon.com/")));
                  },
                ),
              )
            ]),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: MyApp.primarycolor,
          title: Text('Total:' + calculateTotal().toString() + ' USD',
              style: TextStyle(
                color: Colors.white,
              )),
          actions: <Widget>[
            Container(
              width: 60.0,
              child: FlatButton(
                textColor: Colors.white,
                onPressed: () {},
                child: Text("Cart"),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              ),
            ),
          ],
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              Expanded(
                child: ListView(
                    scrollDirection: Axis.vertical, children: createList()),
              ),
              checkOutButton,
            ])),
        /**
            floatingActionButton:FloatingActionButton.extended(
            onPressed: () {
            Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon("https://www.amazon.com/")));
            },
            icon: Icon(Icons.add_shopping_cart),
            label: Text("Shop More"),
            backgroundColor: Colors.deepOrange,
            ),**/
      );
    }
  }
}
