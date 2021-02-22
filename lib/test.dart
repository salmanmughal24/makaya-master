import 'package:badges/badges.dart';
import 'package:device_id/device_id.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:makaya/AliExpress/AliExpressWebView.dart';
import 'package:makaya/fashionnova/FashionNovaWebView.dart';
import 'package:makaya/forever21/Forever21DataParsing.dart';
import 'package:makaya/forever21/Forever21WebView.dart';
import 'package:makaya/hm/hmWebView.dart';
import 'package:makaya/homedepot/homeDepotWebView.dart';
import 'package:makaya/lowes/lowesWebView.dart';
import 'package:makaya/macys/macysWebView.dart';
import 'package:makaya/shein/sheinWebView.dart';
import 'package:makaya/vipoutlet/vipOutletWebView.dart';
import 'package:makaya/walmart/WalmartWebView.dart';
import 'package:makaya/zaful/zafulWebView.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Api/Api.dart';
import 'BottomBar.dart';
import 'Profile.dart';
import 'ViewCart.dart';
import 'ViewFavItems.dart';
import 'ebay/EbayWebView.dart';
import 'main.dart';
import 'amazon/parsing.dart';
import 'amazon/webview.dart';
import 'login.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class GridLayout extends StatefulWidget {
  GridLayout({Key key}) : super(key: key);

  @override
  Stores createState() => new Stores();
}

class Stores extends State<GridLayout> {
  List<String> events = [
    "Amazon",
    "Walmart",
    "Ebay",
    "AliExpress",
    "Forever 21",
    "Vip Outlet",
    "Fashion Nova",
    "Macys",
    "Zaful",
    "Shein",
    "HM",
    "Lowes",
    "Home Depot"
  ];
  List<String> _newData = [];

  _onChanged(String value) {
    setState(() {
      _newData = events
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  TextEditingController editingController = TextEditingController();

  Future<bool> logout(BuildContext context) async {
    String device_id = await DeviceId.getID;
    final response = await http.post(MyApp.base_url + "/User/logout", body: {
      "device_id": device_id,
    }); // make DELETE request

    int statusCode = response.statusCode;
    print(statusCode);

    // print(Navigator.defaultRouteName);

    MyApp.user = null;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    /**
        if(MyApp.user ==null){
        return Scaffold(

        body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        new ButtonTheme(
        minWidth: 400.0,
        padding: new EdgeInsets.all(0.0),
        child: FlatButton(
        child: Text("Please Login again?",
        style: TextStyle(
        color: Colors.blueGrey[900], fontSize: 15.0),),
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(
        builder: (context) => LoginPage()));
        },

        ),
        )
        ]


        ),


        );
        }**/

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: MyApp.primarycolor,
        title: Text(
          'Makaya',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Badge(
            animationType: BadgeAnimationType.slide,
            position: BadgePosition(top: 0, right: 0),
            badgeColor: Colors.white,
            badgeContent: Text(MyApp.aitems.length.toString()),
            child: new IconButton(
                icon: new Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Api.getCart().then((success) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewCartItems()))
                      });
                }),
          ),
        ],
      ),
      drawer: Container(
        color: MyApp.primarycolor,
        child: Container(
          width: 230,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: <Widget>[
              Container(
                color: MyApp.primarycolor,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/makaya.png'),
                    ),
                  ),
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child: ListTile(
                  title: Text(
                    'Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: new Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Api.addCart().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewCartItems()));
                    });
                  },
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child: ListTile(
                  title: new Text(
                    'Stores',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: new Icon(Icons.store, color: Colors.white),
                  onTap: () {
                    Alert(
                      context: context,
                      type: AlertType.error,
                      title: "Sorry!!",
                      desc: "we'll be adding more stores soon!!",
                      buttons: [
                        DialogButton(
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Color(0XFF2B567E), fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          width: 100,
                        )
                      ],
                    ).show();

                    // Navigator.push(context,MaterialPageRoute(builder: (context) => ViewCartItems()));

                    // Navigator.pop(context);
                  },
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child: ListTile(
                  title: new Text(
                    'Favourites',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading:
                      new Icon(FontAwesomeIcons.heart, color: Colors.white),
                  onTap: () {
                    Api.addFav().then((sucess) {
                      print("adding to favorites");

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewFavItems()));
                    });
                  },
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child: isLoginText,
              ),
              Container(
                  color: MyApp.primarycolor,
                  child: ListTile(
                    title: new Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: new Icon(Icons.power_settings_new,
                        color: Colors.white),
                    onTap: () {
                      Alert(
                        context: context,
                        type: AlertType.warning,
                        title: "Logout",
                        desc: "Are you sure you wnat to logout? ",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance.signOut().then((value) => {
                              Phoenix.rebirth(context)

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
                  )),

              /* ListTile(

              title: new Text('Feedback'),
              leading: new Icon(Icons.feedback),

              onTap: () {

                Navigator.pop(context);
              },
            ),*/
              /*ListTile(

              title: new Text('Account'),
              leading: new Icon(Icons.person),

              onTap: () {

                Navigator.pop(context);
              },
            ),*/
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _onChanged,
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)))),
              ),
            ),
            SizedBox(height: 5.0),
            _newData != null && _newData.length != 0
                ? Expanded(
                    child: GridView(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: _newData.map((title) {
                          return GestureDetector(
                            child: Card(
                              margin: const EdgeInsets.all(20.0),
                              child: getCardByTitle(title),
                            ),
                            onTap: () {
                              if (title == "Amazon") {
                                MyApp.url = "https://www.amazon.com";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebViewAmazon(
                                            "https://www.amazon.com")));
                              }
                              if (title == "Walmart") {
                                MyApp.url = "https://www.walmart.com";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WalmartWebView(
                                            "https://www.walmart.com")));
                              }
                              if (title == "Ebay") {
                                MyApp.url = "https://www.ebay.com";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EbayWebView(
                                            "https://www.ebay.com")));
                              }
                              if (title == "Forever 21") {
                                MyApp.url = "https://www.forever21.com/us/shop";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Forever21WebView(
                                            "https://www.forever21.com/us/shop")));
                              }
                              if (title == "Vip Outlet") {
                                MyApp.url = "https://vipoutlet.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VipOutletWebView(
                                            "https://vipoutlet.com/")
                                    )
                                );
                              }
                              if (title == "Macys") {
                                MyApp.url = "https://www.macys.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MacysWebView(
                                            "https://www.macys.com/")
                                    )
                                );
                              }
                              if (title == "Zaful") {
                                MyApp.url = "https://www.zaful.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ZafulWebView(
                                            "https://www.zaful.com/")
                                    )
                                );
                              }
                              if (title == "Shein") {
                                MyApp.url = "https://www.shein.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SheinWebView(
                                            "https://www.shein.com/")
                                    )
                                );
                              }
                              if (title == "HM") {
                                MyApp.url = "https://www2.hm.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HMWebView(
                                            "https://www2.hm.com/")
                                    )
                                );
                              }
                              if (title == "Lowes") {
                                MyApp.url = "https://www.lowes.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LowesWebView(
                                            "https://www.lowes.com/")
                                    )
                                );
                              }
                              if (title == "Home Depot") {
                                MyApp.url = "https://www.homedepot.com/";

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeDepotWebView(
                                            "https://www.homedepot.com/")
                                    )
                                );
                              }
                              /*
                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

*/
                            },
                          );
                        }).toList()),
                  )
                : SizedBox(),
            Expanded(
              child: GridView(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: events.map((title) {
                    return GestureDetector(
                      child: Card(
                        margin: const EdgeInsets.all(20.0),
                        child: getCardByTitle(title),
                      ),
                      onTap: () {
                        if (title == "Amazon") {
                          MyApp.url = "https://www.amazon.com";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      WebViewAmazon("https://www.amazon.com")));
                        }
                        if (title == "Walmart") {
                          MyApp.url = "https://www.walmart.com";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WalmartWebView(
                                      "https://www.walmart.com")));
                        }
                        if (title == "Ebay") {
                          MyApp.url = "https://www.ebay.com";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EbayWebView("https://www.ebay.com")));
                        }
                        if (title == "AliExpress") {
                          MyApp.url = "https://www.aliexpress.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AliExpressWebView(
                                      "https://www.aliexpress.com/")));
                        }
                        if (title == "Forever 21") {
                          MyApp.url = "https://www.forever21.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Forever21WebView(
                                      "https://www.forever21.com/")));
                        }
                        if (title == "Vip Outlet") {
                          MyApp.url = "https://vipoutlet.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VipOutletWebView(
                                      "https://vipoutlet.com/")
                              )
                          );
                        }
                        if (title == "Fashion Nova") {
                          MyApp.url = "https://www.fashionnova.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FashionNovaWebView(
                                      "https://www.fashionnova.com/")
                              )
                          );
                        }
                        if (title == "Macys") {
                          MyApp.url = "https://www.macys.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MacysWebView(
                                      "https://www.macys.com/")
                              )
                          );
                        }
                        if (title == "Zaful") {
                          MyApp.url = "https://www.zaful.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ZafulWebView(
                                      "https://www.zaful.com/")
                              )
                          );
                        }
                        if (title == "Shein") {
                          MyApp.url = "https://www.shein.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SheinWebView(
                                      "https://www.shein.com/")
                              )
                          );
                        }
                        if (title == "HM") {
                          MyApp.url = "https://www2.hm.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HMWebView(
                                      "https://www2.hm.com/")
                              )
                          );
                        }
                        if (title == "Lowes") {
                          MyApp.url = "https://www.lowes.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LowesWebView(
                                      "https://www.lowes.com/")
                              )
                          );
                         }
                        if (title == "Home Depot") {
                          MyApp.url = "https://www.homedepot.com/";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeDepotWebView(
                                      "https://www.homedepot.com/")
                              )
                          );
                        }
                        /*   if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

                if(title=="Amazon")
                  Navigator.push(context,MaterialPageRoute(builder: (context) => WebViewAmazon(  "https://www.amazon.com",true)));

*/
                      },
                    );
                  }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  bool _islogintrue = false;
  Widget isLoginText;

  _checkState() {
    setState(() {
      if (MyApp.user != null) {
        isLoginText = ListTile(
          title: new Text(MyApp.user.email),
          leading: new Icon(Icons.person),
          onTap: () {
            if (MyApp.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );
        print("doodh wari");

        _islogintrue = true;
      } else {
        isLoginText = ListTile(
          title: new Text("Login"),
          leading: new Icon(Icons.power_settings_new),
          onTap: () {
            if (MyApp.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            } else {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "Logout",
                desc: "Are you sure you wnat to logout? ",
                buttons: [
                  DialogButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage())),
                    color: Color.fromRGBO(0, 179, 134, 1.0),
                  ),
                  DialogButton(
                    child: Text(
                      "No",
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
            }

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );

        _islogintrue = false;
      }
    });
  }

  Column getCardByTitle(String title) {
    String img = "";
    if (title == "Amazon")
      img = "assets/images/image2.png";
    else if (title == "Walmart")
      img = "assets/images/walmart.png";
    else if (title == "Olx")
      img = "assets/images/image0.png";
    else if (title == "AliExpress")
      img = "assets/images/image1.png";
    else if (title == "DSW")
      img = "assets/images/image2.png";
    else if (title == "Etsy")
      img = "assets/images/image4.png";
    else if (title == "Ebay")
      img = "assets/images/image5.png";
    else if (title == "Forever 21")
      img = "assets/images/forever21logo.png";
    else if (title == "Vip Outlet")
      img = "assets/images/vipoutlet_logo.png";
    else if (title == "Zaful")
      img = "assets/images/zaful_logo.png";
    else if (title == "Macys")
      img = "assets/images/macys_logo.jpeg";
    else if (title == "HM")
      img = "assets/images/hm_logo.jpg";
    else if (title == "Fashion Nova")
      img = "assets/images/fashionnova.jpg";
    else if (title == "Shein")
      img = "assets/images/shein_logo.png";
    else if (title == "Home Depot")
      img = "assets/images/homedepot.png";
    else if (title == "Lowes")
      img = "assets/images/lowes_logo.png";
    else
      img = "assets/images/image2.png";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Center(
          child: Container(
            child: new Stack(
              children: <Widget>[
                new Image.asset(
                  img,
                  width: 80.0,
                  height: 80.0,
                )
              ],
            ),
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
