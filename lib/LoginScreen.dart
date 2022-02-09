import 'package:emergency_app/CreateAccountScreen.dart';
import 'package:emergency_app/DatabaseHelper.dart';
import 'package:emergency_app/ScanQRScreen.dart';
import 'package:emergency_app/Global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:emergency_app/User.dart';

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

    List userData = await DatabaseHelper.db
        .checkUser(_usernameController!.text, _passwordController!.text);

    if (userData.isNotEmpty) {
      G.loggedUser = User(
          id: userData[0]["ID"],
          firstName: userData[0]["FirstName"],
          middleName: userData[0]["MiddleName"],
          lastName: userData[0]["LastName"],
          email: userData[0]["Email"],
          contact: userData[0]["ContactNo"]);

      _openDialog(CupertinoIcons.checkmark_alt_circle_fill,
          'Successfully Logged In!', 0.22, Colors.greenAccent[400]!);
      Future.delayed(Duration(seconds: 3), () => _openScanQRScreen());
    } else {
      _openDialog(CupertinoIcons.clear_circled_solid,
          'Wrong username or password.', 0.20, Colors.greenAccent[300]!);
    }
  }

  _openScanQRScreen() async {
    await Navigator.pushNamed(context, ScanQrScreen.ROUTE_ID);
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
        padding: EdgeInsets.all(30),
        color: Color(0xFF29C5F6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.amber[400],
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: Container(
                padding: EdgeInsets.all(35),
                child: Image(image: AssetImage('images/location-icon_v.png')),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 22),
              child: Text('Log In Rescue 42\nAccount',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600)),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 3),
              child: Column(
                children: [_inputField('Username', _usernameController!)],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              child: Column(
                children: [_inputField('Password', _passwordController!)],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: () {
                validateUser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber[400]),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: screenWidth! * 0.261, vertical: 12)),
                side: MaterialStateProperty.all(
                    BorderSide(color: Color(0xFF29C5F6), width: 0)),
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
            TextButton(
              onPressed: () {
                _openCreateAccountScreen();
              },
              child: const Text("SIGN UP",
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
      style: TextStyle(
          fontFamily: 'Montserrat', color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              fontFamily: 'Montserrat', color: Colors.white, fontSize: 14),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(10.0)),
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                content: Stack(
                    overflow: Overflow.visible,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
