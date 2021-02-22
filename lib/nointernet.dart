import 'package:badges/badges.dart';
import 'package:device_id/device_id.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'Api/Api.dart';
import 'Profile.dart';
import 'ViewFavItems.dart';
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
class NoInternet extends StatefulWidget
{

  WebViewController value;
  NoInternet(this.value);

  NoInternetState createState() => new NoInternetState(value);
}
class NoInternetState extends State<NoInternet> {

  WebViewController value;
  NoInternetState(this.value);








  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      appBar:    AppBar(
    iconTheme: new IconThemeData(color: Colors.white),

    backgroundColor:MyApp.primarycolor,

    title:Text(
    "Shop",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,)) ,
    actions: <Widget>[

     /* IconButton(

        icon:  new Icon(
          Icons.search,
          color: Colors.white),

      ),*/


      Badge(
        animationType: BadgeAnimationType.slide,
        position: BadgePosition(top: 0,right: 0),
        badgeColor:Colors.white,
        badgeContent: Text(MyApp.aitems.length.toString()),
        child: new IconButton(icon: new Icon(Icons.shopping_cart,color: Colors.white,), onPressed: (){

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ViewCartItems()));


        }),

      ),

    ],

    ),
      drawer: Container(

        color: MyApp.primarycolor,


        child:Container(
          width: 230,
          height: MediaQuery.of(context).size.height,
          child: ListView(

            children: <Widget>[
              Container(

                color: MyApp.primarycolor,

                child:DrawerHeader(


                  decoration: BoxDecoration(

                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/makaya.png'),


                    ),

                  ),
                ),
              ),



              Container(
                color: MyApp.primarycolor,

                child:
                ListTile(
                  title: Text('Cart',style: TextStyle(color: Colors.white),),
                  leading: new Icon(Icons.shopping_cart,color: Colors.white,),

                  onTap: () {

                    Api.addCart().then((value) {

                      Navigator.push(context, MaterialPageRoute(builder: (context) => ViewCartItems()));

                    });

                  },
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child:
                ListTile(


                  title: new Text('Stores',style: TextStyle(color: Colors.white),),
                  leading: new Icon(Icons.store,color: Colors.white),

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
                child:
                ListTile(


                  title: new Text('Favourites',style: TextStyle(color: Colors.white),),
                  leading: new Icon(FontAwesomeIcons.heart,color: Colors.white),

                  onTap: () {
                    Api.addFav().then((sucess){


                      print("adding to favorites");

                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ViewFavItems()));

                    });
                  },
                ),
              ),
              Container(
                color: MyApp.primarycolor,
                child:
                isLoginText,

              ),
              Container(
                  color: MyApp.primarycolor,
                  child:

                  Visibility(

                    visible: _islogintrue,

                    child: ListTile(

                      title: new Text('Logout',style: TextStyle(color: Colors.white),),
                      leading: new Icon(Icons.power_settings_new,color: Colors.white),

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
                              onPressed: (){


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
                    ) ,

                  )
              ),



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

      body:

      Center(

        child:WillPopScope(

          onWillPop: (){

            MyApp.checkInternet().then((value){

              if(value){

                this.value.reload();
                Navigator.pop(context);


                }else{




                }


              });




          },

          child:Center(


          child:Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(

              child:IconButton(
                iconSize: 260,
                icon:Image.asset("assets/images/nointernet.png",fit:BoxFit.contain,),
                onPressed: (){

                },
              ),
            ),
            Text("Sorry...",style: TextStyle(fontSize: 24),),
            Text("",style: TextStyle(fontSize: 24),),
            Container(
              margin:EdgeInsets.only(left:18.0) ,
              child: Text("We're having trouble with your request. Please check your connection andd try again.",style: TextStyle(fontSize: 16),),

            ),

            Text("",style: TextStyle(fontSize: 24),),
            FlatButton(
              color:Colors.blueAccent,
              textColor: Colors.white,
              child: Text("Retry"),
              onPressed: (){

                MyApp.checkInternet().then((value){

                  if(value){

                    if(this.value==null){

                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => WebViewAmazon("https://www.amazon.com/")));

                    }else{

                      this.value.reload();
                      Navigator.pop(context);

                    }


                  }else{



                  }

                });


              },


            )

          ],

        ),
        ),
        ),

      ),



    );



  }

  bool _islogintrue= false;
  Widget isLoginText;
  _checkState(){

    setState(() {

      if(MyApp.user!=null){

        isLoginText = ListTile(

          title: new Text(MyApp.user.email),
          leading: new Icon(Icons.person),

          onTap: () {


            if(MyApp.user!=null){

              Navigator.push(context,MaterialPageRoute(builder: (context) => Profile()));

            }else{

              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));

            }

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));

          },
        );
        print("doodh wari");

        _islogintrue = true;

      }else{

        isLoginText = ListTile(

          title:new Text("Login"),
          leading: new Icon(Icons.power_settings_new),

          onTap: () {


            if(MyApp.user!=null){

              Navigator.push(context,MaterialPageRoute(builder: (context) => Profile()));

            }else{

              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));

            }

            //  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));

          },
        );

        _islogintrue= false;

      }

    });

  }


}