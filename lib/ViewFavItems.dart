import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';
import 'amazon/webview.dart';
import 'checkout.dart';
import 'Api/Api.dart';
import 'main.dart';
import 'dart:core';

class ViewFavItems extends StatefulWidget {
  @override
  ViewFav createState() => new ViewFav();
}

class ViewFav extends State<ViewFavItems> {
  Widget showData(String key, String value) {
    if (value == "" || value == null) {
      return Container(
        height: 0.0,
      );
    } else {
      return Container(
          padding: EdgeInsets.only(top: 30.0),
          child: Text(
            key + " : " + value,
            style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.normal),
          ));
    }
  }

  void remove(index) {
    setState(() {
      MyApp.witems.removeAt(index);
    });
  }

  String getNewLineString(String readLines) {
    String temp = "";

    if (readLines.length > 35) readLines = readLines.substring(0, 35);
    List<String> tempp = readLines.split(" ");

    for (int i = 0; i < tempp.length; i++) {
      if (i % 3 == 0) {
        temp += "\n";
      }
      temp += tempp[i] + " ";
    }
    return temp;
  }

  Widget myDetailsContainer1(int i) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Row(
                children: <Widget>[
                  new Container(
                    width: 200.0,
                    height: 200.0,
                    margin: EdgeInsets.only(right: 50, top: 15),
                    decoration: new BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        image: new NetworkImage(MyApp.witems[i].image),
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
                          margin: EdgeInsets.only(left: 0.0),
                          child: Text(
                            getNewLineString(MyApp.witems[i].title.toString()) +
                                "....",
                            maxLines: 10,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.normal),
                          )),
                    ],
                  ),
                ],
          )),
        ),
        Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              "Merchant:" + MyApp.witems[i].merchant.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal),
            )
        ),
        Container(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              "Price:" + MyApp.witems[i].price,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.normal),
            )),
        showData("Weight", MyApp.witems[i].wegiht),
        showData("Color", MyApp.witems[i].color),
        showData("Size", MyApp.witems[i].size),
        Container(
            height: 300.0,
            padding: EdgeInsets.only(top: 30.0),
            child: Row(
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
                                  WebViewAmazon(MyApp.witems[i].url)));
                    },
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(left: 80),
                ),
                new Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: MyApp.primarycolor)),
                    child: new ButtonTheme(
                      minWidth: 280.0,
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
                                  Api.deleteItem(i).then((value) =>
                                      {remove(i), Navigator.pop(context)});
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

  List<Widget> createList() {
    List<Widget> w = new List<Widget>();

    for (int i = 0; i < MyApp.witems.length; i++) {
      w.add(Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: new FittedBox(
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
                        padding: const EdgeInsets.only(left: 10.0),
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
          "Checkout",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        color: MyApp.primarycolor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CheckOut()));
        },
      ),
    );
    final totalAmount = Text('Total Amount=2800',
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    final totalItems = Text('Total Items=' + MyApp.witems.length.toString(),
        style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
            fontSize: 20));
    if (MyApp.witems.length == 0) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.white),
          backgroundColor: MyApp.primarycolor,
          title: Container(
            height: 80,
            width: 80,
            child: Image.asset(
              'assets/images/makaya.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text("Favourites"),
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
                    "No Items added to wishlist.Want to add items at wishlist?",
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
          title: Container(
            height: 80,
            width: 80,
            child: Image.asset(
              'assets/images/makaya.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              textColor: Colors.white,
              onPressed: () {},
              child: Text("Favourites"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              SizedBox(height: 10.0),
              //checkOutButton,
              Expanded(
                child: ListView(
                    scrollDirection: Axis.vertical, children: createList()),
              ),
            ])),
      );
    }
  }
}
