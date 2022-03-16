import 'dart:convert';
import 'dart:io';

import 'package:emergency_app/widgets/pages/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/widgets/pages/QRScreen/QRScreen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'main_page_screen';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  double? screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        color: Color(0xFFFF6961),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Color(0xFFFFE080),
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Container(
                padding: EdgeInsets.all(5),
                child: Image(image: AssetImage('images/location-icon_v.png')),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: Text('Rescue 42 App',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Text(
                'Emergency Response',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 0.3),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                _openLoginScreen();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: screenWidth! * 0.261, vertical: 12)),
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.white, width: 2.5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("LOGIN",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 2,
            ),
            OutlinedButton(
              onPressed: () {
                _openScanQrScreen();
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: screenWidth! * 0.17, vertical: 12)),
                side: MaterialStateProperty.all(
                    BorderSide(color: Colors.white, width: 2.5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("SCAN TO CALL",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }

  _openLoginScreen() async {
    await Navigator.pushNamed(context, LoginScreen.ROUTE_ID);
  }

  _openScanQrScreen() async {
    await Navigator.pushNamed(context, QRScreen.ROUTE_ID);
  }
}
