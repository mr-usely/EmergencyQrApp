import 'package:emergency_app/QRScreen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:emergency_app/User.dart';
import 'package:emergency_app/Global.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'scan_qr_screen';

  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  double? screenHeight, screenWidth;
  List<User> userDetails = [];

  _openQRScreen() async {
    await Navigator.pushNamed(context, QRScreen.ROUTE_ID);
  }

  @override
  void initState() {
    userDetails = G.getUsers(G.loggedUser!);
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
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(10),
              child: QrImage(
                data:
                    '''Name: ${G.loggedUser!.firstName!} ${G.loggedUser!.middleName!} ${G.loggedUser!.lastName!}
                Email: ${G.loggedUser!.email!}
                Phone: ${G.loggedUser!.contact!}
                      ''',
                version: QrVersions.auto,
                size: 250,
                gapless: false,
                embeddedImage: AssetImage('images/location-icon_v.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(80, 80),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            OutlinedButton(
              onPressed: () {
                _openQRScreen();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber[400]),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                    horizontal: screenWidth! * 0.185, vertical: 12)),
                side: MaterialStateProperty.all(
                    BorderSide(color: Color(0xFF29C5F6), width: 0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("Scan QR to Call",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
