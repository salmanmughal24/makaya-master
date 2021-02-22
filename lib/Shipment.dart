import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:makaya/main.dart';

class Shipment extends StatefulWidget {
  ShipmentState createState() => new ShipmentState();
}

class ShipmentState extends State<Shipment> {
  var selectdecor = new BoxDecoration(
    color: Color.fromRGBO(0, 0, 200, 245),
    border:Border.all(
        width: 4,
        color: Colors.blue
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(20.0) //         <--- border radius here
    ),
  );
  var unselectdecor = new BoxDecoration(
    color: Color.fromRGBO(0, 0, 0, 0),
    border:Border.all(
        width: 4,
        color: Colors.white70
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(20.0) //         <--- border radius here
    ),
  );
  int _value = 0;
  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: MyApp.primarycolor,
      ),
      body: Container(
        color: Colors.black12,
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child:  Container(
                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenwidth / 2 - 20,
                      height: screenwidth / 2 - 20,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset("assets/shipmentimg/c1.jpg"),
                            flex: 1,
                          ),
                          Text("0 - .5 lbs")
                        ],
                      ),
                    ),
                    Container(
                      height: screenwidth / 2,
                      width: screenwidth / 2,
                      child: Image.asset("assets/shipmentimg/c11.jpg"),
                      padding: EdgeInsets.all(10),
                    ),
                  ],
                ),
                foregroundDecoration: _value == 1 ? selectdecor : unselectdecor,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0) //         <--- border radius here
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  _value=1;
                });
              },
            ),
            GestureDetector(
              child:  Container(

                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenwidth / 2 - 20,
                      height: screenwidth / 2 - 20,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset("assets/shipmentimg/c2.jpg"),
                            flex: 1,
                          ),
                          Text(".5 - 3 lbs")
                        ],
                      ),
                    ),
                    Container(
                      height: screenwidth / 2,
                      width: screenwidth / 2,
                      child: Image.asset("assets/shipmentimg/c22.jpg"),
                      padding: EdgeInsets.all(20),
                    ),
                  ],
                ),
                foregroundDecoration: _value == 2 ? selectdecor : unselectdecor,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0) //         <--- border radius here
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  _value=2;
                });
              },
            ),
            GestureDetector(
              child:  Container(

                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenwidth / 2 - 20,
                      height: screenwidth / 2 - 20,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset("assets/shipmentimg/c3.jpg"),
                            flex: 1,
                          ),
                          Text("3 - 10 lbs")
                        ],
                      ),
                    ),
                    Container(
                      height: screenwidth / 2,
                      width: screenwidth / 2,
                      child: Image.asset("assets/shipmentimg/c33.jpg"),
                      padding: EdgeInsets.all(20),
                    ),
                  ],
                ),
                foregroundDecoration: _value == 3 ? selectdecor : unselectdecor,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0) //         <--- border radius here
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  _value=3;
                });
              },
            ),
            GestureDetector(
              child:  Container(

                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenwidth / 2 - 20,
                      height: screenwidth / 2 - 20,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Image.asset("assets/shipmentimg/c4.jpg"),
                            flex: 1,
                          ),
                          Text("10 - 20 lbs")
                        ],
                      ),
                    ),
                    Container(
                      height: screenwidth / 2,
                      width: screenwidth / 2,
                      child: Image.asset("assets/shipmentimg/c44.jpg"),
                      padding: EdgeInsets.all(20),
                    ),
                  ],
                ),
                foregroundDecoration: _value == 4 ? selectdecor : unselectdecor,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(20.0) //         <--- border radius here
                  ),
                ),
              ),
              onTap: (){
                setState(() {
                  _value=4;
                });
              },
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20)
              ),
              margin: EdgeInsets.all(20),
              child: RaisedButton(
                child: Text(
                  "Place Order", style: TextStyle(color: Colors.white, fontSize: 20.0),),
                color: MyApp.primarycolor,


                onPressed: () {
                  Map<String,dynamic> dd={};
                  int i = 0;
                  MyApp.aitems.map((e) => e.toJsonAttr()).toList().forEach((element) {
                   dd[i.toString()] = element;
                   i++;
                 });
                  FirebaseFirestore.instance.collection('orders').add(dd);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      )
    );
  }
}
