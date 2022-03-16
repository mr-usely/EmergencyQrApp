import 'dart:convert';

import 'package:emergency_app/widgets/pages/CreateAccountScreen/CreateAccountScreen.dart';
import 'package:emergency_app/widgets/Database/DatabaseHelper.dart';
import 'package:emergency_app/widgets/Global/Global.dart';
import 'package:emergency_app/widgets/pages/ScanQRScreen/ScanQRScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double? screenHeight, screenWidth;
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;

  validateUser() async {
    if (_usernameController!.text.isEmpty &&
        _passwordController!.text.isEmpty) {
      _openDialog(CupertinoIcons.exclamationmark_circle_fill,
          'Kindly fill out empty fields.', 0.25, Colors.deepOrange[300]!);
      return;
    }

    var response = await http.get(Uri.parse(
        '${G.link}/user/${_usernameController!.text}/${_passwordController!.text}/auth'));
    print(response.body);
    var res = User.fromJson(jsonDecode(response.body));

    // List userData = await DatabaseHelper.db
    //     .checkUser(_usernameController!.text, _passwordController!.text);

    if (response.body.isNotEmpty) {
      G.loggedUser = User(
          id: res.id,
          firstName: res.firstName,
          lastName: res.lastName,
          birthDate: res.birthDate,
          organDonnor: res.organDonnor,
          allergy: res.allergy != null ? res.allergy : ' ',
          email: res.email,
          contact: res.contact,
          pathology: res.pathology,
          medication: res.medication,
          persontocontact: res.persontocontact,
          relation: res.relation,
          contactnumber: res.contactnumber);
      G.isScanned = false;
      _openDialog(CupertinoIcons.checkmark_alt_circle_fill,
          'Successfully Logged In!', 0.22, Colors.greenAccent[400]!);
      Future.delayed(const Duration(seconds: 3), () => _openScanQRScreen());
    } else {
      _openDialog(CupertinoIcons.clear_circled_solid,
          'Wrong username or password.', 0.20, Colors.deepOrange[300]!);
      return;
    }
  }

  _openScanQRScreen() async {
    await Navigator.pushReplacementNamed(context, ScanQrScreen.ROUTE_ID);
  }

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        color: const Color(0xFFFF6961),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Color(0xFFFFE080),
                  borderRadius: const BorderRadius.all(Radius.circular(100))),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Image(
                    image: AssetImage('images/location-icon_v.png')),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 22),
              child: const Text('Log In Rescue 42\nAccount',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 3),
              child: Column(
                children: [_inputField('Username', _usernameController!)],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Column(
                children: [_inputField('Password', _passwordController!)],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {
                validateUser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFFFFE080)),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: screenWidth! * 0.261, vertical: 12)),
                side: MaterialStateProperty.all(
                    const BorderSide(color: Color(0xFFFF6961), width: 0)),
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
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: label == 'Password' ? true : false,
      style: const TextStyle(
          fontFamily: 'Montserrat', color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
              fontFamily: 'Montserrat', color: Colors.white, fontSize: 14),
          border: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: const EdgeInsets.all(10.0)),
    );
  }

  _openDialog(IconData iconName, String message, double width, Color color) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: AlertDialog(
                elevation: 0.0,
                insetPadding:
                    EdgeInsets.symmetric(horizontal: screenWidth! * width),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                content: Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Positioned(
                          top: screenHeight! * -.079,
                          child: Icon(
                            iconName,
                            size: 65,
                            color: color,
                          ))
                    ]),
              ),
              onWillPop: null);
        });
  }

  _openCreateAccountScreen() async {
    await Navigator.pushNamed(context, CreateAccountScreen.ROUTE_ID);
  }
}
