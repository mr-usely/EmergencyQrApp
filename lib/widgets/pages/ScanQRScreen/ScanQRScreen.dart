import 'package:emergency_app/widgets/pages/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/ProfileDetailsScreen.dart';
import 'package:emergency_app/widgets/pages/QRScreen/QRScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:emergency_app/widgets/Global/Global.dart';

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

  _openMyProfileScreen() async {
    await Navigator.pushNamed(context, ProfileDetailsScreen.ROUTE_ID);
  }

  _loggedOut() async {
    await Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_ID);
  }

  Future<bool> _onBackPressed(BuildContext context) async => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0.0,
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth! * 0.2),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w600))),
            TextButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text("Ok",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        fontWeight: FontWeight.w600)))
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: Text('Do you really want to exit?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
              ),
              Positioned(
                  top: screenHeight! * -.079,
                  child: Icon(
                    CupertinoIcons.exclamationmark_circle_fill,
                    size: 65,
                    color: Colors.amber[300],
                  ))
            ],
          ),
        );
      }).then((v) => v ?? false);

  @override
  void initState() {
    userDetails = G.getUsers(G.loggedUser!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        appBar: app_bar(),
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
                  padding: EdgeInsets.all(10),
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
                      "app: brgy_rescue_hotline&${G.loggedUser!.firstName!} ${G.loggedUser!.lastName!}&${G.loggedUser!.birthDate!}&${G.loggedUser!.organDonnor!}&${G.loggedUser!.allergy!}&${G.loggedUser!.email!}&${G.loggedUser!.contact!}&${G.loggedUser!.pathology!}&${G.loggedUser!.medication!}&${G.loggedUser!.persontocontact!}&${G.loggedUser!.relation!}&${G.loggedUser!.contactnumber!}",
                  version: QrVersions.auto,
                  size: 250,
                  gapless: false,
                  embeddedImage: const AssetImage('images/location-icon_v.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(90, 90),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              OutlinedButton(
                onPressed: () {
                  _openQRScreen();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFFFE080)),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: screenWidth! * 0.185, vertical: 12)),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Color(0xFFFF6961), width: 0)),
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
      ),
    );
  }

  // Appbar
  PreferredSizeWidget app_bar() => AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFF6961),
        leading: IconButton(
            onPressed: () => _openMyProfileScreen(),
            icon: const Icon(
              CupertinoIcons.bars,
              size: 42,
            )),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () => _loggedOut(),
                icon: Icon(
                  CupertinoIcons.square_arrow_right,
                  size: 42,
                )),
          ),
        ],
        title: const Text(
          'Scan QR',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
        ),
        centerTitle: true,
      );
}
