import 'dart:convert';

import 'package:emergency_app/widgets/BasicLifeSupport/BasicLifeSupportMenu.dart';
import 'package:emergency_app/widgets/Global/Global.dart';
import 'package:emergency_app/widgets/Models/BasicLifeSupport.dart';
import 'package:emergency_app/widgets/Models/Contacts.dart';
import 'package:emergency_app/widgets/Models/Pathologies.dart';
import 'package:emergency_app/widgets/Models/ScannedUser.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:emergency_app/widgets/pages/LoginScreen/LoginScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/ContactsWidget.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/PathologiesWidget.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/ProfileWidget.dart';
import 'package:emergency_app/widgets/pages/ScanQRScreen/ScanQRScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'profile_details_screen';

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  double? screenHeight, screenWidth;
  bool isTapLifeSupport = false;
  List<Contacts> contactInfo = [];
  List<Pathologies> pathologyList = [];
  List<User> userDetails = [];
  List<ScannedUser> scannedUser = [];

  List<BasicLifeSupport> basicSupportList = [
    BasicLifeSupport(
        id: 1,
        title: 'Danger',
        description:
            'Make sure it is safe for you, the casualty and bystanders.',
        subDescription: '',
        image: 'images/danger.png'),
    BasicLifeSupport(
        id: 2,
        title: 'Response',
        description: 'use a talk and touch technique to check for a response.',
        subDescription:
            'Talk: "Can you hear me?", "Open your eyes". Touch: "squeeze shoulders firmly."',
        image: 'images/response.png'),
    BasicLifeSupport(
        id: 3,
        title: 'Send',
        description: 'Shout for help or send someone to call Tripple Zero(000)',
        subDescription:
            'It requiredl send for help at the earliest possible stage.',
        image: 'images/send.png'),
    BasicLifeSupport(
        id: 4,
        title: 'Airway',
        description:
            'Use the head tilt and chin lift technique to open the airway.',
        subDescription:
            'It blocked turn the casualty onto their side and clear their airway.',
        image: 'images/airway.png'),
    BasicLifeSupport(
        id: 5,
        title: 'Breathing',
        description: 'Look, listen and feel for normal breathing.',
        subDescription:
            'If not breathing or not breathing normally, commence CPR.',
        image: 'images/breathing.png'),
    BasicLifeSupport(
        id: 6,
        title: 'CPR',
        description:
            'Give **30 Compressions** followed by **2 rescue breaths.**',
        subDescription:
            'if unable or unwilling to give rescue breaths, give compression only CPR.',
        image: 'images/cpr.png'),
    BasicLifeSupport(
        id: 7,
        title: 'Defibrillator',
        description:
            'Attach an AED* as soon as available and follow the prompts.',
        subDescription: '*AED: Automated External Defibrillator',
        image: 'images/defi.png')
  ];

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

  _isLoadContent(bool isScanned) async {
    if (isScanned) {
      scannedUser.add(ScannedUser(
          name: G.scannedUser!.name,
          birthDate: G.scannedUser!.birthDate,
          allergy: G.scannedUser!.allergy));

      contactInfo.add(Contacts(
          accountID: G.getContacts!.accountID,
          contactName: G.getContacts!.contactName,
          contactRelation: G.getContacts!.contactRelation,
          phoneNumber: G.getContacts!.phoneNumber));

      pathologyList.add(Pathologies(
          accountID: G.getPathologies!.accountID,
          medID: G.getPathologies!.medID,
          sickness: G.getPathologies!.sickness,
          medicines: G.getPathologies!.medicines));
    } else {
      contactInfo.add(Contacts(
          accountID: 0,
          contactName: G.loggedUser!.persontocontact,
          contactRelation: G.loggedUser!.relation,
          phoneNumber: G.loggedUser!.contactnumber));

      pathologyList.add(Pathologies(
          accountID: 0,
          medID: 0,
          sickness: G.loggedUser!.pathology,
          medicines: G.loggedUser!.medication!.split(',').toList()));
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoadContent(G.isScanned!);
  }

  _openScanQRScreen(bool isScanned) async {
    await Navigator.pushNamed(
        context, isScanned ? LoginScreen.ROUTE_ID : ScanQrScreen.ROUTE_ID);
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
            padding: EdgeInsets.all(20),
            color: Color(0xFFFF6961),
            child: ListView(
              children: <Widget>[
                G.isScanned!
                    ? ProfileWidget(
                        isLoading: scannedUser.isEmpty ? true : false,
                        name: scannedUser[0].name,
                        birthday: scannedUser[0].birthDate,
                        organDonor: 'Organ Donor',
                        allergy: scannedUser[0].allergy,
                      )
                    : ProfileWidget(
                        isLoading:
                            G.loggedUser!.firstName!.isEmpty ? true : false,
                        name:
                            '${G.loggedUser!.firstName} ${G.loggedUser!.lastName}',
                        birthday: G.loggedUser!.birthDate,
                        organDonor: 'Organ Donor',
                        allergy: G.loggedUser!.allergy,
                      ),
                SizedBox(
                  height: 10,
                ),
                ContactsWidget(
                  contactInfo: contactInfo,
                  isLoading: contactInfo.isEmpty ? true : false,
                ),
                SizedBox(
                  height: 10,
                ),
                PathologiesWidget(
                  pathologyList: pathologyList,
                  isLoading: pathologyList.isEmpty ? true : false,
                ),
                SizedBox(
                  height: 10,
                ),
                BasicLifeSupportMenu(
                    isTap: isTapLifeSupport,
                    list: basicSupportList,
                    onTap: () {
                      setState(() {
                        isTapLifeSupport = !isTapLifeSupport;
                      });
                    })
              ],
            ),
          )),
    );
  }

  PreferredSizeWidget app_bar() => AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFF6961),
        leading: IconButton(
            onPressed: () {
              _openScanQRScreen(G.isScanned!);
            },
            icon: const Icon(
              CupertinoIcons.back,
              size: 33,
            )),
        title: Text(
          'My Profile',
          style: TextStyle(fontFamily: 'Montserrat', fontSize: 20),
        ),
        centerTitle: true,
      );
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
