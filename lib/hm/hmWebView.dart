
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:makaya/Profile.dart';
import 'package:makaya/ViewFavItems.dart';
import 'package:makaya/nointernet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../BottomBar.dart';
import '../Api/Api.dart';
import '../login.dart';
import '../ViewCart.dart';
import '../main.dart';
import 'package:badges/badges.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class HMWebView extends StatefulWidget {
  String url = "";
  bool check = false;

  HMWebView(this.url);

  @override
  HMWebViewState createState() {
    try {
      return new HMWebViewState(this.url);
    } catch (Exception) {
      print(Exception);
    }
  }
}

class HMWebViewState extends State<HMWebView> {
  static int counter = 0;
  ScrollController _scrollController;
  bool _visible = true;
  bool _appIndicator = false;
  bool _nav_visibilty = false;
  String url = "";

  HMWebViewState(this.url);

  Completer<WebViewController> _controller = Completer<WebViewController>();
  String temporyurl = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() => _visible = false);
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() => _visible = true);
      }
    });

    if (this.url.contains("/productpage.")) {
      _showAddToCartButton(true);
      temporyurl = url;
      MyApp.url = url;
    } else {
      MyApp.objHMPrsing.reset();
      _showAddToCartButton(false);
    }

    startTimer();
  }

  _showAddToCartButton(bool check) {
    setState(() {
      _nav_visibilty = check;
      MyApp.enteredProductPage = check;
    });
  }

  _showAppBarIndicator(bool check) {
    setState(() {
      _appIndicator = check;
    });
  }

  int _incrementTab() {
    int count = 0;
    setState(() {
      count = MyApp.aitems.length;
    });
    return count;
  }

  static int count = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Key _key = new Key("webview");

  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileHtmlContents =
        await rootBundle.loadString("assets/nointernet.html");
    controller.loadUrl(Uri.dataFromString(fileHtmlContents,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  Widget isLoginText;
  Widget UserLoggedin;

  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          _checkState();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isParsing = true;

    Widget webScreen = new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 10,
        title: Container(
            height: 100,
            width: 200,
            child: Image.asset('assets/images/makaya_appbar.jpg')),
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: MyApp.primarycolor,
        actions: <Widget>[
          Visibility(
            visible: _appIndicator,
            child: new Container(
                width: 50.0,
                height: 50.0,
                color: MyApp.primarycolor,
                child: new CircularProgressIndicator()),
          ),

          //favorities

          IconButton(
              icon: new Icon(
                FontAwesomeIcons.heart,
                color: Colors.white,
              ),
              onPressed: () {
                // _showAppBarIndicator(true);
                _controller.future.then((test) {
                  test.currentUrl().then((value) {
                    print("\n\n\n\n\n");
                    print(value);
                    print("\n\n\n\n\n");
                    temporyurl = value;
                    if (temporyurl.contains("/productpage.") ) {
                      MyApp.showProgressDialog(context, "Adding to Favroties");

                      MyApp.objHMPrsing
                          .viewProduct(temporyurl)
                          .then((success) {
                        if (MyApp.objHMPrsing.parsedSuccess && success) {
                          print("Done Scrapping");
                          int check =
                              MyApp.objHMPrsing.addTofav(temporyurl);
                          String desc = "";
                          String title = "";
                          AlertType alertType = AlertType.success;

                          if (check == 0) {
                            alertType = AlertType.error;
                            desc = "Something not right Please try again";
                            title = "Error";
                          } else if (check == 1) {
                            alertType = AlertType.success;
                            title = "Success";
                            desc = "Item Added to Favroties";
                          } else if (check == 2) {
                            alertType = AlertType.info;
                            title = "Info";
                            desc = "Item already in Favroties";
                          } else {
                            alertType = AlertType.error;
                            title = "OOPs";
                            desc =
                                "Please Select all attributes before adding to cart";
                          }
                          _incrementTab();
                          if (Navigator.canPop(context)) Navigator.pop(context);

                          Alert(
                            context: context,
                            type: alertType,
                            title: title,
                            desc: desc,
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
                          // _showAppBarIndicator(false);
                        } else {
                          Navigator.pop(context);
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Sorry",
                            desc: "the product is not available at the moment",
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
                        }
                      });
                    }
                  });
                });
              }),

          // go back to previous page

          IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.future.then((onValue) {
                  navigate(context, onValue, goBack: true);

                  _controller.future.then((value) {
                    value.currentUrl().then((value) {
                      String url = value;
                      if (url.contains("/productpage.")) {
                        _showAddToCartButton(true);
                      } else {
                        _showAddToCartButton(false);
                      }
                    });
                  });
                });
              }),

          // Refresh Page

          IconButton(
              icon: new Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.future.then((onValue) {
                  MyApp.checkInternet().then((check) {
                    if (check) {
                      onValue.currentUrl().then((url) {
                        if (url.contains("/productpage.")) {
                          _showAddToCartButton(true);
                        }

                        onValue.loadUrl(url);
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoInternet(onValue)));
                    }
                  });
                });
              }),

          // Go Forward

          IconButton(
              icon: new Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: () {
                print("wait");
                _controller.future.then((onValue) {
                  navigate(context, onValue, goBack: false).then((nothing) {
                    onValue.currentUrl().then((url) {
                      print(url);
                      if (url.contains("/productpage.")) {
                        _showAddToCartButton(true);
                      }
                    });
                  });
                });
              }),

          Badge(
            animationType: BadgeAnimationType.slide,
            position: BadgePosition(top: 0, right: 0),
            badgeColor: Colors.white,
            badgeContent: Text(_incrementTab().toString()),
            child: new IconButton(
                icon: new Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Api.addCart().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCartItems()));
                  });
                  //  FlutterWebviewPlugin fwvp = new FlutterWebviewPlugin();
                }),
          ),
        ],
      ),
      body: WebView(
        key: _key,
        javascriptMode: JavascriptMode.unrestricted,
        javascriptChannels: Set.from([
          // JavascriptChannel(
          //     name: 'Print',
          //     onMessageReceived: (JavascriptMessage message) {
          //       print("hello world");
          //       print(message.message);
          //     })
        ]),
        initialUrl: url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        navigationDelegate: (NavigationRequest nav) {
          MyApp.checkInternet().then((check) {
            if (check) {
              String value = nav.url;
              MyApp.url = nav.url;
              temporyurl = value;
              if (url.contains("/productpage.")) {
                if (isParsing == false) {
                  isParsing = true;
                  _showAddToCartButton(true);
                  temporyurl = value;

                  _controller.future.then((webviewtest) {
                    webviewtest
                        .evaluateJavascript(
                            "document.getElementById('title').innerHTML")
                        .then((something) {
                      print(something);
                    });
                  });
                }
              } else {
                MyApp.objHMPrsing.reset();
                _showAddToCartButton(false);
              }

              //  return NavigationDecision.navigate;

            } else {
              _showAddToCartButton(false);
              _controller.future.then((value) {
                //loadHtmlFromAssets("",value);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NoInternet(value)));
              });
            }
          });

          return NavigationDecision.navigate;
        },
        onPageFinished: (url) {
          print("====your page is load");
          if (url.contains("/productpage.")) {
            _showAddToCartButton(true);
          }
        },
        onPageStarted: (url){
          if (url.contains("/productpage.")) {
            _showAddToCartButton(true);
          }
        },
      ),
      floatingActionButton: Visibility(
        visible: _nav_visibilty,
        child: new FloatingActionButton.extended(
            label: new Text(
              'Add to Makaya Cart                       ',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              //_showAppBarIndicator(true);
              _controller.future.then((test) {
                test.currentUrl().then((value) {
                  MyApp.checkInternet().then((check) {
                    if (check) {
                      print("\n\n\n\n\n");
                      print(value);
                      print("\n\n\n\n\n");
                      temporyurl = value;

                      MyApp.showProgressDialog(context, "Adding to Cart");

                      MyApp.objHMPrsing
                          .viewProduct(temporyurl)
                          .then((success) {
                        if (MyApp.objHMPrsing.parsedSuccess && success) {
                          print("Done Scrapping");
                          int check =
                              MyApp.objHMPrsing.addTocart(temporyurl);
                          String desc = "";
                          String title = "";
                          AlertType alertType = AlertType.success;

                          if (check == 0) {
                            alertType = AlertType.error;
                            desc = "Something not right Please try again";
                            title = "Errror";
                          } else if (check == 1) {
                            alertType = AlertType.success;
                            title = "Success";
                            desc = "Item Added to Cart";
                          } else if (check == 2) {
                            alertType = AlertType.info;
                            title = "Success";
                            desc = "Item Updated in Cart";
                          } else {
                            alertType = AlertType.error;
                            title = "OOPs";
                            desc =
                                "Please Select size and color before adding to cart";
                          }
                          _incrementTab();
                          if (Navigator.canPop(context)) Navigator.pop(context);

                          Alert(
                            context: context,
                            type: alertType,
                            title: title,
                            desc: desc,
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
                          // _showAppBarIndicator(false);
                        } else {
                          Navigator.pop(context);
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Sorry",
                            desc: "the product is not available at the moment",
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
                        }
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NoInternet(test)));
                    }
                  });
                });
              });
            }),
      ),
      //floatingActionButton: NavigationControls(_controller.future),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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
              UserLoggedin,
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
                child: isLoginText,
              )

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
    );
    return webScreen;
  }

  bool _islogintrue = false;


  @override
  void dispose() {

    super.dispose();
  }

  _checkState() {
    setState(() {
      if (MyApp.user != null) {
        UserLoggedin = ListTile(
          title: new Text(
            MyApp.user.email,
            style: TextStyle(color: Colors.white),
          ),
          leading: new Icon(
            Icons.person,
            color: Colors.white,
          ),
          onTap: () {
            if (MyApp.user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            } else {}

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );
        print("doodh wari");

        isLoginText = ListTile(
          title: new Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          leading: new Icon(Icons.power_settings_new, color: Colors.white),
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
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    MyApp.user = null;
                    _checkState();
                    Navigator.pop(context);
                  },
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
          },
        );

        _islogintrue = true;
      } else {
        UserLoggedin = Container(
          height: 0.0,
        );

        isLoginText = ListTile(
          title: new Text("Login", style: TextStyle(color: Colors.white)),
          leading: new Icon(
            Icons.power_settings_new,
            color: Colors.white,
          ),
          onTap: () {
            if (MyApp.user != null) {
              /*
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
                    onPressed: () =>  Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage())),
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
              */

              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            }

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
          },
        );

        _islogintrue = false;
      }
    });
  }

  Future<void> navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack
          ? controller.goBack().then((value) {})
          : controller.goForward().then((val) {});
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("Sem histórico anterior")),
      );
    }
  }
}
