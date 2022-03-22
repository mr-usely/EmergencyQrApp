import 'dart:io';

import 'package:emergency_app/widgets/Global/Global.dart';
import 'package:emergency_app/widgets/Models/Contacts.dart';
import 'package:emergency_app/widgets/Models/Pathologies.dart';
import 'package:emergency_app/widgets/Models/ScannedUser.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/MyProfileScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/ProfileDetailsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'qr_screen';

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  double? screenHeight, screenWidth;
  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(alignment: Alignment.center, children: <Widget>[
      buildQRView(context),
      Positioned(bottom: 10, child: buildResult()),
      Positioned(top: 10, child: buildControlButtons())
    ]));
  }

  Widget buildControlButtons() => Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: FutureBuilder<bool?>(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return Icon(
                        snapshot.data!
                            ? CupertinoIcons.bolt_fill
                            : CupertinoIcons.bolt_slash_fill,
                        color: Colors.white60,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              ),
              IconButton(
                icon: FutureBuilder(
                    future: controller?.getCameraInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Icon(
                          CupertinoIcons.camera_rotate_fill,
                          color: Colors.white60,
                        );
                      } else {
                        return Container();
                      }
                    }),
                onPressed: () async {
                  await controller?.flipCamera();
                  setState(() {});
                },
              )
            ]),
      );

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(8)),
        child: Text(
          barcode != null ? 'Result : ${barcode!.code}' : 'Scan a code!',
          maxLines: 3,
        ),
      );

  Widget buildQRView(BuildContext context) => QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Theme.of(context).accentColor,
        borderRadius: 10,
        borderLength: 20,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.65,
      ));

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);

    controller.scannedDataStream.listen((barcode) => setState(() async {
          this.barcode = barcode;

          if (barcode != null) {
            List<String> result = barcode.code.toString().split('&');
            // _openDialog(CupertinoIcons.checkmark_alt_circle_fill,
            //     result.toString(), 0.3, Colors.greenAccent[400]!);
            //validate if app: brgy_rescue_hotline
            if (result[0] == "app: brgy_rescue_hotline") {
              G.isScanned = true;
              
              var response = await http.post(
                    Uri.parse(
                        '${G.link}/report/${result[5].toString()}/emergency'),
                    headers: {"Accept": "application/json"},
                    body: {"location": "Jones, Isabela"});

                print(response.body + '${result[5]}');
              
              G.scannedUser = ScannedUser(
                  name: result[1],
                  birthDate: result[2],
                  organDonnor: result[3] == null
                      ? false
                      : result[3] == 1
                          ? true
                          : false,
                  allergy: result[4],
                  email: result[5],
                  contact: result[6]);

              G.getContacts = Contacts(
                  accountID: 0,
                  contactName: result[9],
                  contactRelation: result[10],
                  phoneNumber: result[11]);

              G.getPathologies = Pathologies(
                  accountID: 0,
                  medID: 0,
                  sickness: result[7],
                  medicines: result[8].split(',').toList());
              _openMyProfileScreen();
            } else {
              print('invalid qr');
            }
          }
        }));
  }

  _openMyProfileScreen() async {
    await Navigator.pushReplacementNamed(
        context, ProfileDetailsScreen.ROUTE_ID);
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
}
