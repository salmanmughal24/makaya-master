import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:makaya/login.dart';
import 'test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:core';
class SignUp extends StatefulWidget
{
  static String tag="signup";
  @override
  SignUpState createState( )=> new SignUpState();

}
class SignUpState extends State<SignUp>
{
  TextEditingController nameController=new TextEditingController();
  TextEditingController emailController=new TextEditingController();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController addressController=new TextEditingController();
  final formKey=GlobalKey<FormState>();
  Future <List> signUp () async
  {
/*      final response = await http.post(
          "http://192.168.1.10/Makaya/User/createUser",
          body: {
        "name": nameController.text,
        "address": addressController.text,
        "email": emailController.text,
        "password": passwordController.text,
      });
      var data = json.encode(response.body);*/
    
    //  UserCredential userCredential= await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).catchError();
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text)
          .then((currentUser) => {
            if(currentUser!=null){
              currentUser.user.updateProfile(displayName: nameController.text,photoURL: addressController.text).then((value) => {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GridLayout()))
              }
              ).catchError((onError)=>{

                FlutterToast.showToast(msg: onError.message)
              })

            }
        //Execute
      }).catchError((onError)=>{
        FlutterToast.showToast(msg: onError.message)
        //Handle error i.e display notification or toast
      });

  }

  @override
  Widget build(BuildContext context) {
    final logo=Hero(
      tag:'tanawul',
      child:CircleAvatar(
        backgroundColor:Colors.transparent,
        radius:48.0,
        child:Image.asset('assets/images/makaya_round.png'),

      ),

    );
    final name=TextFormField(
      keyboardType:TextInputType.text,
      autofocus: false,
      controller:nameController,
      validator:(value){
        if(value.isEmpty)
          return "Please Enter Name";
      },
      decoration:InputDecoration(

          hintText:'NAME',
          contentPadding:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0,),
          border:OutlineInputBorder(borderRadius:BorderRadius.circular(32.0) )

      ),

    );
    final email=TextFormField(
      keyboardType:TextInputType.emailAddress,
      autofocus: false,

      controller:emailController ,
      validator:(value){
        if(value.isEmpty)
          return "Please Enter Email";
      },
      decoration:InputDecoration(
          hintText:'EMAIL',
          contentPadding:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0,),
          border:OutlineInputBorder(borderRadius:BorderRadius.circular(32.0) )

      ),

    );
    final address=TextFormField(
      keyboardType:TextInputType.text,
      autofocus: false,
      controller:addressController ,
      validator:(value){
        if(value.isEmpty)
          return "Please Enter Address";
      },
      decoration:InputDecoration(
          hintText:'ADDRESS',

          contentPadding:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0,),
          border:OutlineInputBorder(borderRadius:BorderRadius.circular(32.0) )

      ),

    );
    final password=TextFormField(
      obscureText:true,
      autofocus: false,
      controller:passwordController,
      validator:(value){
        if(value.isEmpty)
          return "Please Enter Password";
      },
      decoration:InputDecoration(
          hintText:'PASSWORD',
          contentPadding:EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0,),
          border:OutlineInputBorder(borderRadius:BorderRadius.circular(32.0), )


      ),

    );
    final signUpButton=new ButtonTheme(
      minWidth: 330.0,
      padding: new EdgeInsets.all(0.0),
      child: RaisedButton(
        child:Text("Sign Up",style:TextStyle(color:Colors.white,fontSize: 20.0),),
        color:Color(0XFF2B567E),


        onPressed:()
        {
          signUp();

        },
      ),
    );

    return Scaffold(
      backgroundColor:Colors.white,
      body:Form(key:formKey,
        child:SingleChildScrollView(
          child:Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:60.0),
            logo,
            SizedBox(height:80.0),
            name,
            SizedBox(height:20.0),
            email,
            SizedBox(height:20.0),
            address,
            SizedBox(height:20.0),
            password,
            SizedBox(height:20.0),
            signUpButton,
            SizedBox(height:20.0),
            FlatButton(
              onPressed: () {
                           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>LoginPage()));
              },
              textColor: Theme.of(context).hintColor,
              child: Text('Go to Login'),
            )

          ],
        ),
      ),
      ),
    );
  }

}