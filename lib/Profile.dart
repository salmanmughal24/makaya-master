import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:makaya/styles/theme.dart' as Theme;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'main.dart';


class Profile extends StatefulWidget
{
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupAddressController = new TextEditingController();


  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;


  @override
  Widget build(BuildContext context) {


   // signupEmailController.text = MyApp.user.email;
    signupNameController.text = MyApp.user.name;

    signupAddressController.text = MyApp.user.address;


    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Padding(

            padding: EdgeInsets.only(top: 20.0),
            child: new Image(
                width: 170.0,
                height: 150.0,
                fit: BoxFit.fill,
                image: new AssetImage('assets/images/makaya_round.png')),
          ),

          Stack(
            alignment: Alignment.topCenter,
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 220.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(

                          controller: signupNameController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.user,
                              color: Colors.black,
                            ),
                            hintText: "Name",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),
                      ),
//                      Container(
//                        width: 250.0,
//                        height: 1.0,
//                        color: Colors.grey[400],
//                      ),
//                      Padding(
//                        padding: EdgeInsets.only(
//                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
//                        child: TextField(
//
//                          controller: signupEmailController,
//                          keyboardType: TextInputType.emailAddress,
//                          style: TextStyle(
//                              fontFamily: "WorkSansSemiBold",
//                              fontSize: 16.0,
//                              color: Colors.black),
//                          decoration: InputDecoration(
//                            border: InputBorder.none,
//                            icon: Icon(
//                              FontAwesomeIcons.envelope,
//                              color: Colors.black,
//                            ),
//                            hintText: "Email Address",
//                            hintStyle: TextStyle(
//                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
//                          ),
//                        ),
//                      ),

                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(

                          controller: signupAddressController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(
                              fontFamily: "WorkSansSemiBold",
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.addressCard,
                              color: Colors.black,
                            ),
                            hintText: "Address",
                            hintStyle: TextStyle(
                                fontFamily: "WorkSansSemiBold", fontSize: 16.0),
                          ),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 200.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Theme.Colors.loginGradientStart,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Theme.Colors.loginGradientEnd,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        Theme.Colors.loginGradientEnd,
                        Theme.Colors.loginGradientStart
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Theme.Colors.loginGradientEnd,
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: "WorkSansBold"),
                    ),
                  ),
                  onPressed:()
                  {

                    UpdateProfle();
                    //session();

                  },
                ),
              ),
            ],

          ),
        ],
      ),
    );





  }


  Future<void> UpdateProfle() async{

    print(MyApp.base_url+"/User/updateUser/"+MyApp.user.id);

    final response = await http.post(
        MyApp.base_url+"/User/updateUser/"+MyApp.user.id,
        body: {
          "name": signupNameController.text,
          "address": signupAddressController.text,
         // "email": signupEmailController.text,
         // "password": signupPasswordController.text,
        });
    var data = json.decode(response.body);
    print(data);
    if(data["success"]!=null)
    {

      MyApp.user.name = signupNameController.text;
      MyApp.user.address = signupAddressController.text;
   //   MyApp.user.email = signupEmailController.text;



      Alert(
        context: context,
        type: AlertType.success,
        title: "Success",
        desc: "Account Information Updated!!",
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



}