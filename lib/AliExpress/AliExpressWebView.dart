import 'dart:io';

import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main.dart';
import '../models/listAttributes.dart';

import 'package:html/dom.dart' as dom;

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:html/parser.dart' show parse;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:makaya/Profile.dart';
import 'package:makaya/ViewFavItems.dart';
import 'package:makaya/models/listAttributes.dart';
import 'package:makaya/nointernet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../BottomBar.dart';
import '../Api/Api.dart';
import '../login.dart';
import 'aliExpressparsing.dart';
import '../ViewCart.dart';
import '../test.dart';
import '../checkout.dart';
import '../main.dart';
import 'package:badges/badges.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:core';

class AliExpressWebView extends StatefulWidget {


  String url = "";
  bool check = false;

  AliExpressWebView(this.url);

  @override
  AliExpressWebViewState createState() {
    try {
      return new AliExpressWebViewState(this.url);
    } catch (Exception) {
      print(Exception);
    }
  }
}

class AliExpressWebViewState extends State<AliExpressWebView> {
  static int counter = 0;
  ScrollController _scrollController;
  bool _visible = true;
  bool _appIndicator = false;
  bool _nav_visibilty = false;
  String url = "";

  String title;
  String price;
  String type="";
  String weight;
  String image;
  String size;
  String color="";

  static all_listAttributes item;
  bool parsedSuccess = false;



  AliExpressWebViewState(this.url);

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

    /* if(this.url.contains("/item")||this.url.contains("/d/")) {
        _showAddToCartButton(true);
        temporyurl = url;
        MyApp.url = url;

    }else{

      MyApp.objAliExpressPrsing.reset();
      _showAddToCartButton(false);

    }*/

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
    bool isParsing = false;

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
                    if (temporyurl.contains("/item") ||
                        temporyurl.contains("/d/")) {
                      MyApp.showProgressDialog(context, "Adding to Favroties");

                      viewProduct(temporyurl, test)
                          .then((success) {
                        if (parsedSuccess &&
                            success) {
                          print("Done Scrapping");
                          int check =
                              addTofav(temporyurl);
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
                      //      String url = value;
                      /* if(url.contains("/item")||url.contains("/d/")) {

                          _showAddToCartButton(true);

                        }else{

                          _showAddToCartButton(false);

                        }*/
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
                        /*  if(url.contains("/item")||url.contains("/d/")) {

                      _showAddToCartButton(true);
                    }


                      onValue.loadUrl(url);*/
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
                    /*  onValue.currentUrl().then((url){

                  print(url);
                  if(url.contains("/item")||url.contains("/d/")) {
                      _showAddToCartButton(true);
                    }

                 });*/
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
             /* if (nav.url.contains("/item") || nav.url.contains("/d/")) {
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
                MyApp.objAliExpressPrsing.reset();
                _showAddToCartButton(false);
              }*/

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
          setState(() async {
            var web = await _controller.future;
            print("====your page is load");
            if (temporyurl.contains("/item")) {



              _showAddToCartButton(true);
            }
            print("thihsih" + url);
          });
        },
      ),
      floatingActionButton: new Visibility(
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
              _controller.future.then((web) {
                web.currentUrl().then((value) {
                  MyApp.checkInternet().then((check) {
                    if (check) {
                      print("\n\n\n\n\n");
                      print(value);
                      print("\n\n\n\n\n");
                      temporyurl = value;

                      MyApp.showProgressDialog(context, "Adding to Cart");

                      viewProduct(temporyurl, web)
                          .then((success) async {
                        if (parsedSuccess &&
                            success) {
                          print("Done Scrapping");
                          var im = await web.evaluateJavascript(
                              "window.document.getElementsByClassName('_1BGt5')[0].getElementsByClassName('slide')[0].getElementsByTagName('img')[0].attributes['src'].value;");
                          if (im != null) {
                            image = im.replaceAll(" ", "").replaceAll("\"", "");
                          }
                          print("Image" + image);
                          String tt = await web.evaluateJavascript(
                              "window.document.getElementsByClassName('Kgxt-')[0].innerText");

                          if (tt != null) {
                            title = tt.replaceAll("\"", "");
                          }else{
                            tt="";
                          }
                          print("Title" + title);

                          var pp = await web.evaluateJavascript(
                              "window.document.getElementsByClassName('_2Ip_s')[0].innerText;");
                          if (pp != null) {
                            price = pp.split(" ").last.replaceAll("\$", "").replaceAll("\"", "");
                          }
                          print("Price" + price);

                          var cl = await web.evaluateJavascript(
                              "window.document.getElementsByClassName('_1wyOZ')[0].innerText;");
                          if (cl != null) {
                            color = cl.trim().replaceAll(":", "").replaceAll("\"", "");
                          }else{
                            color="";
                          }
                          print("Color" + color);

                          var fr = await web.evaluateJavascript(
                              "window.document.getElementsByClassName('_1wyOZ')[1].innerText;");
                          if (fr != null) {
                            type = fr.trim().replaceAll(":", "").replaceAll("\"", "");
                            int check =
                            addTocart(temporyurl);
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
                            } else if (check == 22) {
                              alertType = AlertType.error;
                              title = "OOPs";
                              desc =
                              "Please select Shipping and color before adding to cart";
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
                          }
                          print("Type" + type);

                          // _showAppBarIndicator(false);
                        } else {
                    //      dom.Document document = (await web.evaluateJavascript("window.document")) as dom.Document;

                   //     print("THI "+document.body.innerHtml);



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
                              builder: (context) => NoInternet(web)));
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


  Future<bool> viewProduct(String url, WebViewController controller) async {
    print('url is :$url');
    var menu = null;
    try {
      print('see url');
      print(url);
      print('see url');

      if (url == null || url == "") return false;
      menu = await http.get(url);
      this.url = url;
      print('response is: ${menu.body}');
      var document = parse(menu.body);
      print('response is document: $document');
      if (parse_page(controller, document, "") == -1) {
        return false;
      } else
        return true;
    } on Exception catch (e) {
      print("check");
      print('Page parsing is called checked exception');
      print(e);
      return false;
    }
    //return menu.body;
  }

  Future<int> parse_page(
      WebViewController web, dom.Document document, String type2) async {
    //get image
    print('Page parsing is called');
    try {


      parsedSuccess = true;
      return 1;
    } on Exception catch (e) {
      print("error was : ");
      print(e);
      return -1;
    }
  }

  int addTocart(String url) {
    if((color == ""||color =="null")||(type == ""||type =="null")||(color ==null)||(type == null)){
      print("HUHUHUUHU"+color+type);
      return 22;
    }else{
      int flag = 0;
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
          "Ali Express",
          this.size,
          url);
      MyApp.aitems.add(temp);

      if (flag == 0) {
        return 1;
      }

      else {
        return 0;
      }

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
