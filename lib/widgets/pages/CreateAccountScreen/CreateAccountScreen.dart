import 'package:emergency_app/widgets/pages/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/widgets/Database/DatabaseHelper.dart';
import 'package:emergency_app/widgets/pages/ScanQRScreen/ScanQRScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'create_account_screen';

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  double? screenHeight, screenWidth;
  DateTime selectedDate = DateTime.now();
  TextEditingController? _firstnameController;
  TextEditingController? _birthdayController;
  TextEditingController? _lastnameController;
  TextEditingController? _usernameController;
  TextEditingController? _passwordController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;

  // function for selecting date
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1800),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
      fieldLabelText: 'Birth Date',
      fieldHintText: 'Month/Day/Year',
      errorFormatText: 'Enter valid date',
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _birthdayController!.text =
            selectedDate.toLocal().toString().split(' ')[0];
        print(_birthdayController!.text);
      });
  }

  // add user and go to log in if success
  addUser() async {
    if (_firstnameController!.text.isEmpty &&
        _birthdayController!.text.isEmpty &&
        _lastnameController!.text.isEmpty &&
        _usernameController!.text.isEmpty &&
        _passwordController!.text.isEmpty &&
        _emailController!.text.isEmpty &&
        _phoneController!.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                child: AlertDialog(
                  elevation: 0.0,
                  insetPadding:
                      EdgeInsets.symmetric(horizontal: screenWidth! * 0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'Kindly fill all the fields!',
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
                              CupertinoIcons.exclamationmark_circle_fill,
                              size: 65,
                              color: Colors.deepOrange[300],
                            ))
                      ]),
                ),
                onWillPop: null);
          });
      return;
    }

    int i = await DatabaseHelper.db.insertUser({
      DatabaseHelper.colFirstName: _firstnameController!.text,
      DatabaseHelper.colLastName: _lastnameController!.text,
      DatabaseHelper.colBirthDate: _birthdayController!.text,
      DatabaseHelper.colUsername: _usernameController!.text,
      DatabaseHelper.colPassword: _passwordController!.text,
      DatabaseHelper.colEmail: _emailController!.text,
      DatabaseHelper.colContactNo: _phoneController!.text,
    });

    if (i != null) {
      _openLoginScreen();
    }
  }

  _openLoginScreen() async {
    await Navigator.pushNamed(context, LoginScreen.ROUTE_ID);
  }

  @override
  void initState() {
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _birthdayController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
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
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Color(0xFFFFE080),
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child:
                        Image(image: AssetImage('images/location-icon_v.png')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 22),
                  child: Text('Rescue 42 App',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 1,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600)),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Column(
                    children: [
                      _inputField('First Name', _firstnameController!)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Column(
                    children: [_inputField('Last Name', _lastnameController!)],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Column(
                    children: [_inputField('Birthday', _birthdayController!)],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Column(
                    children: [_inputField('Email', _emailController!)],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                  child: Column(
                    children: [
                      _inputField('Contact Number', _phoneController!)
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                OutlinedButton(
                  onPressed: () {
                    addUser();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFFFE080)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                        horizontal: screenWidth! * 0.235, vertical: 12)),
                    side: MaterialStateProperty.all(
                        BorderSide(color: Color(0xFFFF6961), width: 0)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                  ),
                  child: const Text("SIGN UP",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600)),
                ),
                TextButton(
                  onPressed: () {
                    _openLoginScreen();
                  },
                  child: const Text("Already have an account?",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      onTap: () {
        label == "Birthday" ? _selectDate(context) : print('input');
      },
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
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.white, width: 2, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.all(10.0)),
    );
  }
}
