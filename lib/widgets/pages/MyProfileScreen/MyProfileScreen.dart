import 'package:emergency_app/widgets/Database/DatabaseHelper.dart';
import 'package:emergency_app/widgets/Global/Global.dart';
import 'package:emergency_app/widgets/Models/Pathologies.dart';
import 'package:emergency_app/widgets/pages/ScanQRScreen/ScanQRScreen.dart';
import 'package:emergency_app/widgets/Models/User.dart';
import 'package:emergency_app/widgets/BasicLifeSupport/BasicLifeSupportMenu.dart';
import 'package:emergency_app/widgets/Models/BasicLifeSupport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emergency_app/widgets/Models/Contacts.dart';
import 'package:flutter/services.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  static const String ROUTE_ID = 'my_profile_screen';

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  double? screenHeight, screenWidth;
  bool? isEditProfile = false;
  bool? isAddContacts = false;
  bool? isAddPathologies = false;
  bool? isEditPathologies = false;
  bool? isAddMedicine = false;
  bool? isTapLifeSupport = false;
  bool? isCollapseLifeSupport = false;
  bool? checkDonnor = false;
  DateTime selectedDate = DateTime.parse(G.loggedUser!.birthDate!);
  List<String> medicine = [];
  List<Contacts> contactInfo = [];
  List<Pathologies> pathologyList = [];
  List<User> userDetails = [];
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
  int? medID = 0;

  TextEditingController? _firstnameController;
  TextEditingController? _lastnameController;
  TextEditingController? _birthdayController;
  TextEditingController? _allergyController;
  TextEditingController? _contactNameController;
  TextEditingController? _contactRelationController;
  TextEditingController? _contactNumberController;
  TextEditingController? _sicknessController;
  TextEditingController? _medicineController;

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

  // clear profile textfield
  _clearProfileInput() {
    _firstnameController!.text = '';
    _lastnameController!.text = '';
    _birthdayController!.text = '';
    _allergyController!.text = '';
  }

  _clearContactsInput() {
    _contactNameController!.text = '';
    _contactRelationController!.text = '';
    _contactNumberController!.text = '';
  }

  // to update profile record in the database
  _updateProfile() async {
    int update = await DatabaseHelper.db.updateProfile({
      DatabaseHelper.colID: G.loggedUser!.id,
      DatabaseHelper.colFirstName: _firstnameController!.text,
      DatabaseHelper.colLastName: _lastnameController!.text,
      DatabaseHelper.colBirthDate: _birthdayController!.text,
      DatabaseHelper.colOrganDonnor: checkDonnor! ? 1 : 0,
      DatabaseHelper.colAllergy: _allergyController!.text
    });

    if (update != 0) {
      _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
          'Profile Updated!', 0.22, Colors.greenAccent[400]!);

      List userData = await DatabaseHelper.db.getUser(G.loggedUser!.id!);

      // if (userData.isNotEmpty) {
      //   setState(() {
      //     G.loggedUser = User(
      //         id: userData[0]["ID"],
      //         firstName: userData[0]["FirstName"],
      //         lastName: userData[0]["LastName"],
      //         birthDate: userData[0]["BirthDate"],
      //         organDonnor: userData[0]["OrganDonnor"] == null
      //             ? false
      //             : userData[0]["OrganDonnor"] == 1
      //                 ? true
      //                 : false,
      //         allergy:
      //             userData[0]["Allergy"] != null ? userData[0]["Allergy"] : ' ',
      //         email: userData[0]["Email"],
      //         contact: userData[0]["ContactNo"]);
      //   });
      // }
    }
  }

  _createContacts() async {
    if (_contactNameController!.text.isEmpty &&
        _contactRelationController!.text.isEmpty &&
        _contactNumberController!.text.isEmpty) {
      _customDialog(context, CupertinoIcons.clear_circled_solid,
          'Kindly fill empty fields!', 0.25, Colors.deepOrange[300]!);

      return;
    }

    int inserted = await DatabaseHelper.db.insertContacts({
      DatabaseHelper.colAccountID: G.loggedUser!.id,
      DatabaseHelper.colContactName: _contactNameController!.text,
      DatabaseHelper.colRelationship: _contactRelationController!.text,
      DatabaseHelper.colPhoneNumber: _contactNumberController!.text
    });

    if (inserted != null) {
      _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
          'Contact Created!', 0.22, Colors.greenAccent[400]!);

      _clearContactsInput();
      _initContacts();
    }
  }

  _createPathologies() async {
    if (_sicknessController!.text.isEmpty) {
      _customDialog(context, CupertinoIcons.clear_circled_solid,
          'Input is empty!', 0.22, Colors.deepOrange[300]!);
      return;
    }

    int inserted = await DatabaseHelper.db.insertPathologies({
      DatabaseHelper.colAccountID: G.loggedUser!.id,
      DatabaseHelper.colSickness: _sicknessController!.text
    });

    if (inserted != 0) {
      _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
          'Contact Created!', 0.22, Colors.greenAccent[400]!);

      //clear text input
      _sicknessController!.text = '';

      // initialize Pathologies List
      _initPathologies();
    }
  }

  _addMedicines() async {
    if (_medicineController!.text.isEmpty) {
      _customDialog(context, CupertinoIcons.clear_circled_solid,
          'Input is empty!', 0.22, Colors.deepOrange[300]!);
      return;
    }

    int addMedicine = await DatabaseHelper.db.updateMedicine({
      DatabaseHelper.colID: medID,
      DatabaseHelper.colAccountID: G.loggedUser!.id,
      DatabaseHelper.colMedicine: _medicineController!.text
    });

    if (addMedicine != 0) {
      _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
          'Added Medicine $addMedicine.', 0.22, Colors.greenAccent[400]!);
      _medicineController!.text = '';
      isAddMedicine = false;
      _initPathologies();
    }
  }

  _deletePathologies(int id) async {
    await DatabaseHelper.db.deletePathology(id, G.loggedUser!.id!);
    _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
        'Delete Item Successfully!', 0.23, Colors.greenAccent[400]!);
  }

  _updatePathologies() async {
    if (_sicknessController!.text.isEmpty &&
        _medicineController!.text.isEmpty) {
      _customDialog(context, CupertinoIcons.clear_circled_solid,
          'Fill out empty fields!', 0.25, Colors.deepOrange[300]!);
      return;
    }
    int update = await DatabaseHelper.db.updatePathologies({
      DatabaseHelper.colID: medID,
      DatabaseHelper.colAccountID: G.loggedUser!.id,
      DatabaseHelper.colSickness: _sicknessController!.text,
      DatabaseHelper.colMedicine: _medicineController!.text
    });

    if (update != 0) {
      _customDialog(context, CupertinoIcons.checkmark_alt_circle_fill,
          'Pathology Updated!', 0.22, Colors.greenAccent[400]!);
      _sicknessController!.text = '';
      _medicineController!.text = '';
      isEditPathologies = false;
      _initPathologies();
    }
  }

  // initialize contacts
  _initContacts() async {
    List contacts = await DatabaseHelper.db.getContacts(G.loggedUser!.id!);
    contactInfo.clear();
    for (var i = 0; i < contacts.length; i++) {
      setState(() => contactInfo.add(Contacts(
          accountID: contacts[i]["AccountID"],
          contactName: contacts[i]["ContactName"],
          contactRelation: contacts[i]["Relationship"],
          phoneNumber: contacts[i]["PhoneNumber"])));
    }
  }

  _initPathologies() async {
    List pathologies =
        await DatabaseHelper.db.getPatholofies(G.loggedUser!.id!);

    pathologyList.clear();

    for (var i = 0; i < pathologies.length; i++) {
      medicine = pathologies[i]["Medicine"] != null
          ? pathologies[i]["Medicine"].split(',')
          : ' , '.split(',');

      setState(() => pathologyList.add(Pathologies(
          accountID: G.loggedUser!.id,
          medID: pathologies[i]["ID"],
          sickness: pathologies[i]["Sickness"],
          medicines: medicine)));
    }
  }

  String getInitials(String getInitial) => getInitial.isNotEmpty
      ? getInitial.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  _openScanQRScreen() async {
    await Navigator.pushNamed(context, ScanQrScreen.ROUTE_ID);
  }

  Future<bool> _onBackPressed(BuildContext context) async => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0.0,
          insetPadding: EdgeInsets.symmetric(horizontal: screenWidth! * 0.3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
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
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _birthdayController = TextEditingController();
    _allergyController = TextEditingController();
    _contactNameController = TextEditingController();
    _contactRelationController = TextEditingController();
    _contactNumberController = TextEditingController();
    _sicknessController = TextEditingController();
    _medicineController = TextEditingController();

    userDetails = G.getUsers(G.loggedUser!);
    _initContacts();
    _initPathologies();

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
            padding: EdgeInsets.all(20),
            color: Color(0xFFFF6961),
            child: ListView(
              children: <Widget>[
                profile(),
                SizedBox(
                  height: 10,
                ),
                contacts(),
                SizedBox(
                  height: 10,
                ),
                pathologies(),
                SizedBox(
                  height: 10,
                ),
                BasicLifeSupportMenu(
                    isTap: isTapLifeSupport,
                    list: basicSupportList,
                    onTap: () {
                      setState(() {
                        isTapLifeSupport = !isTapLifeSupport!;
                      });
                    })
              ],
            ),
          )),
    );
  }

  // Appbar
  PreferredSizeWidget app_bar() => AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFF6961),
        leading: IconButton(
            onPressed: () {
              _openScanQRScreen();
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

  // Profile
  Widget profile() => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Color(0xFFFF6961),
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: SizedBox(
                  width: 30,
                )),
                IconButton(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 1),
                    onPressed: () => setState(() {
                          isEditProfile = !isEditProfile!;
                          _firstnameController!.text = G.loggedUser!.firstName!;
                          _lastnameController!.text = G.loggedUser!.lastName!;
                          _birthdayController!.text = G.loggedUser!.birthDate!;
                          _allergyController!.text = G.loggedUser!.allergy!;
                        }),
                    icon: Icon(
                      !isEditProfile!
                          ? CupertinoIcons.pencil
                          : CupertinoIcons.clear_thick,
                      size: 25,
                      color: Color(0xFFFF6961),
                    ))
              ],
            ),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE080),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CupertinoIcons.person_alt,
                          size: 55,
                          color: Colors.white,
                        )),
                  ),
                  !isEditProfile!
                      ? Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              profileDetails(CupertinoIcons.person,
                                  '${G.loggedUser!.firstName} ${G.loggedUser!.lastName}'),
                              profileDetails(CupertinoIcons.gift_alt,
                                  '${G.loggedUser!.birthDate}'),
                              profileDetails(
                                  G.loggedUser!.organDonnor! == 1 &&
                                          G.loggedUser!.organDonnor! != null
                                      ? CupertinoIcons.heart
                                      : CupertinoIcons.heart_slash,
                                  'Organ Donor'),
                              profileDetails(CupertinoIcons.nosign,
                                  '${G.loggedUser!.allergy}'),
                            ],
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              profileEditor(
                                  'First Name', _firstnameController!),
                              SizedBox(height: 8),
                              profileEditor('Last Name', _lastnameController!),
                              SizedBox(height: 8),
                              Row(
                                children: <Widget>[
                                  profileEditor(
                                      'Birthday', _birthdayController!),
                                  Container(
                                    margin: EdgeInsets.only(left: 4),
                                    child: OutlinedButton(
                                      onPressed: () => _selectDate(context),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xFFFFE080)),
                                        padding: MaterialStateProperty.all(
                                            EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 0)),
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                color: Color(0xFFFFFFFF),
                                                width: 0)),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0))),
                                      ),
                                      child: const Text("Set Date",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Montserrat',
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 2),
                              Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: this.checkDonnor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        this.checkDonnor = value;
                                      });
                                    },
                                    fillColor: MaterialStateProperty.all(
                                        Color(0xFFFF6961)),
                                    side: BorderSide(
                                        color: Color(0xFFFF6961), width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  Text('Organ Donnor',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        color: Color(0xFFFF6961),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  SizedBox(
                                    width: screenWidth! * 0.11,
                                  )
                                ],
                              ),
                              SizedBox(height: 2),
                              profileEditor('Allergy', _allergyController!),
                              SizedBox(height: 2),
                              _sendButton('Update', 0.165, 4, () {
                                setState(() {
                                  _updateProfile();
                                  _clearProfileInput();
                                  isEditProfile = !isEditProfile!;
                                });
                              })
                            ],
                          ))
                ])
          ],
        ),
      );

  Widget profileDetails(IconData icon, String text) => RichText(
        text: TextSpan(children: [
          WidgetSpan(
              child: Icon(
            icon,
            color: Color(0xFFFF6961),
          )),
          WidgetSpan(
              child: SizedBox(
            width: 10,
          )),
          TextSpan(
              text: text,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w700))
        ]),
      );

  Widget profileEditor(String label, TextEditingController controller) =>
      Container(
        width: (label == "Birthday")
            ? (screenWidth! * 0.313)
            : (screenWidth! * 0.5),
        child: Column(
          children: <Widget>[
            TextField(
                controller: controller,
                enabled: label == "Birthday" ? false : true,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFFFF6961),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                    labelText: label,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFFFF6961),
                        fontSize: 14),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFF6961),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFF6961),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFF6961),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xFFFF6961),
                            width: 2,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    contentPadding: EdgeInsets.all(10.0)))
          ],
        ),
      );

  // contacts
  Widget contacts() => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Contacts',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Color(0xFFFF6961),
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: SizedBox(
                  width: 30,
                )),
                IconButton(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 1),
                    onPressed: () => setState(() {
                          isAddContacts = !isAddContacts!;
                        }),
                    icon: Icon(
                      !isAddContacts!
                          ? CupertinoIcons.add_circled
                          : CupertinoIcons.clear_circled,
                      size: 25,
                      color: Color(0xFFFF6961),
                    ))
              ],
            ),
            isAddContacts!
                ? ContactEncoding(
                    nameController: _contactNameController,
                    relationController: _contactRelationController,
                    phoneNoController: _contactNumberController,
                    save: () {
                      setState(() {
                        _createContacts();
                      });
                    },
                  )
                : SizedBox(),
            Column(
              children: List.generate(
                  contactInfo.length,
                  (index) => Row(
                        children: <ContactLists>[
                          ContactLists(
                            name:
                                "${contactInfo[index].contactName!} (${contactInfo[index].contactRelation!})",
                            phoneNumber: contactInfo[index].phoneNumber!,
                            onTap: () {},
                            thumbnail: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  getInitials(contactInfo[index].contactName!),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 25,
                                      letterSpacing: 3,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE080),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15)),
                                )),
                          ),
                        ],
                      )),
            )
          ],
        ),
      );

  // pathologies
  Widget pathologies() => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pathologies',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Color(0xFFFF6961),
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: SizedBox(
                  width: 30,
                )),
                IconButton(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 1),
                    onPressed: () => setState(() {
                          isAddPathologies = !isAddPathologies!;
                          isAddMedicine = false;
                          isEditPathologies = false;
                        }),
                    icon: Icon(
                      !isAddPathologies!
                          ? CupertinoIcons.add_circled
                          : CupertinoIcons.clear_circled,
                      size: 25,
                      color: Color(0xFFFF6961),
                    ))
              ],
            ),
            isAddPathologies!
                ? PathologiesEncoding(
                    textController: _sicknessController,
                    label: 'Illness',
                    function: () => _createPathologies(),
                  )
                : Container(),
            isAddMedicine!
                ? PathologiesEncoding(
                    textController: _medicineController,
                    label: 'Medicines',
                    function: () => _addMedicines(),
                  )
                : Container(),
            isEditPathologies!
                ? EditPathologies(
                    firstInputLabel: 'Illness',
                    firstController: _sicknessController,
                    secondInputLabel: 'Medicines',
                    secondController: _medicineController,
                    function: () => _updatePathologies(),
                  )
                : Container(),
            Column(
              children: List.generate(
                  pathologyList.length,
                  (index) => PathologiesLists(
                        sickness: pathologyList[index].sickness,
                        medicine: pathologyList[index].medicines,
                        listID: pathologyList[index].accountID,
                        isAdd: () {
                          setState(() => isAddMedicine = !isAddMedicine!);
                          medID = pathologyList[index].medID;
                          isAddPathologies = false;
                          isEditPathologies = false;
                        },
                        isDelete: () {
                          setState(() {
                            _deletePathologies(pathologyList[index].medID!);
                            _initPathologies();
                          });
                        },
                        isEdit: () {
                          setState(() {
                            isEditPathologies = !isEditPathologies!;
                            isAddMedicine = false;
                            isAddPathologies = false;
                            _sicknessController!.text =
                                pathologyList[index].sickness!;
                            _medicineController!.text =
                                pathologyList[index].medicines!.join(',');
                          });
                        },
                      )),
            )
          ],
        ),
      );

  Widget _sendButton(
          String buttonText, double btnSizeH, double btnSizeV, Function() fn) =>
      OutlinedButton(
        onPressed: () => fn(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFFFE080)),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: screenWidth! * btnSizeH, vertical: btnSizeV)),
          side: MaterialStateProperty.all(
              BorderSide(color: Color(0xFFFFFFFF), width: 0)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
        ),
        child: Text(buttonText,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat',
                color: Colors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600)),
      );
}

class ContactLists extends StatelessWidget {
  const ContactLists(
      {Key? key,
      required this.thumbnail,
      required this.name,
      required this.phoneNumber,
      this.onTap})
      : super(key: key);

  final Widget thumbnail;
  final String name;
  final String phoneNumber;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap!(),
        child: Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: thumbnail,
              ),
              Expanded(
                  flex: 3,
                  child: ContactDetails(
                    name: name,
                    phoneNumber: phoneNumber,
                  )),
              Expanded(
                child: Icon(CupertinoIcons.phone_arrow_down_left,
                    color: Color(0xFFFFE080), size: 30),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails(
      {Key? key, required this.name, required this.phoneNumber})
      : super(key: key);

  final String name;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Text(
            phoneNumber,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.black54,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class ContactEncoding extends StatelessWidget {
  const ContactEncoding(
      {Key? key,
      required this.nameController,
      required this.relationController,
      required this.phoneNoController,
      this.save})
      : super(key: key);

  final TextEditingController? nameController;
  final TextEditingController? relationController;
  final TextEditingController? phoneNoController;
  final Function()? save;
  @override
  Widget build(BuildContext context) {
    double? screenHeight, screenWidth;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: screenWidth * 0.47,
                child: Column(
                  children: <Widget>[_inputField('Name', nameController)],
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                width: screenWidth * 0.28,
                child: Column(
                  children: <Widget>[
                    _inputField('Relationship', relationController)
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Container(
                width: screenWidth * 0.47,
                child: Column(
                  children: <Widget>[
                    _inputField('Phone Number', phoneNoController)
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              OutlinedButton(
                onPressed: () => save!(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFFFFE080)),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1, vertical: 12)),
                  side: MaterialStateProperty.all(
                      BorderSide(color: Color(0xFFFFFFFF), width: 0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                ),
                child: Text('Save',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController? controller) =>
      TextField(
        controller: controller,
        style: TextStyle(
            fontFamily: 'Montserrat', color: Color(0xFFFF6961), fontSize: 14),
        decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFFFF6961),
                fontSize: 14),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFFF6961),
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFFF6961),
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Color(0xFFFF6961),
                    width: 2,
                    style: BorderStyle.solid),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(10.0)),
      );
}

class PathologiesLists extends StatelessWidget {
  const PathologiesLists(
      {Key? key,
      required this.sickness,
      this.medicine,
      this.isAdd,
      this.isEdit,
      this.isDelete,
      this.listID})
      : super(key: key);

  final int? listID;
  final String? sickness;
  final List<String>? medicine;
  final Function()? isAdd;
  final Function()? isEdit;
  final Function()? isDelete;
  @override
  Widget build(BuildContext context) {
    double? screenWidth;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.red[50], borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                sickness!,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        medicine!.length,
                        (index) => Text("- ${medicine![index]}",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ))),
                  ))
            ],
          ),
          Expanded(
              child: SizedBox(
            width: screenWidth * 0.1,
          )),
          Container(
            child: GroupIconButtons(
              isAdd: () => isAdd!(),
              isDelete: () => isDelete!(),
              isEdit: () => isEdit!(),
            ),
          )
        ],
      ),
    );
  }
}

class PathologiesEncoding extends StatelessWidget {
  const PathologiesEncoding(
      {Key? key, required this.textController, this.label, this.function})
      : super(key: key);
  final TextEditingController? textController;
  final String? label;
  final Function()? function;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              CustomInput(
                controller: textController,
                label: label,
                inputSize: 0.55,
              ),
              SizedBox(
                width: 4,
              ),
              CustomButton(
                buttonText: 'Save',
                btnSizeH: 0.08,
                btnSizeV: 14,
                function: () => function!(),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class EditPathologies extends StatelessWidget {
  const EditPathologies(
      {Key? key,
      this.firstController,
      this.firstInputLabel,
      this.secondInputLabel,
      this.secondController,
      this.function})
      : super(key: key);
  final String? firstInputLabel;
  final TextEditingController? firstController;
  final String? secondInputLabel;
  final TextEditingController? secondController;
  final Function()? function;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Column(
        children: <Widget>[
          GroupTextField(
              firstInputLabel: firstInputLabel,
              firstController: firstController,
              secondInputLabel: secondInputLabel,
              secondController: secondController),
          SizedBox(height: 4),
          CustomButton(
              buttonText: 'Save',
              btnSizeH: 0.34,
              btnSizeV: 14,
              function: () => function!())
        ],
      ),
    );
  }
}

class GroupTextField extends StatelessWidget {
  const GroupTextField(
      {Key? key,
      this.firstController,
      this.firstInputLabel,
      this.secondInputLabel,
      this.secondController})
      : super(key: key);
  final String? firstInputLabel;
  final TextEditingController? firstController;
  final String? secondInputLabel;
  final TextEditingController? secondController;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        CustomInput(
          controller: firstController,
          label: firstInputLabel,
          inputSize: 0.8,
        ),
        const SizedBox(
          height: 8,
        ),
        CustomInput(
          controller: secondController,
          label: secondInputLabel,
          inputSize: 0.8,
        )
      ]),
    );
  }
}

class CustomInput extends StatelessWidget {
  const CustomInput(
      {Key? key, required this.controller, this.label, required this.inputSize})
      : super(key: key);

  final TextEditingController? controller;
  final String? label;
  final double? inputSize;
  @override
  Widget build(BuildContext context) {
    double? screenWidth;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * inputSize!,
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller,
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xFFFF6961),
                fontSize: 14),
            decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFFFF6961),
                    fontSize: 14),
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFF6961),
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFF6961),
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFFF6961),
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                contentPadding: EdgeInsets.all(10.0)),
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.buttonText,
      required this.btnSizeH,
      required this.btnSizeV,
      this.function})
      : super(key: key);

  final String? buttonText;
  final double? btnSizeH;
  final double? btnSizeV;
  final Function()? function;
  @override
  Widget build(BuildContext context) {
    double? screenWidth;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: OutlinedButton(
        onPressed: () => function!(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFFFE080)),
          padding: MaterialStateProperty.all(EdgeInsets.symmetric(
              horizontal: screenWidth * btnSizeH!, vertical: btnSizeV!)),
          side: MaterialStateProperty.all(
              BorderSide(color: Color(0xFFFFFFFF), width: 0)),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0))),
        ),
        child: Text(buttonText!,
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Montserrat',
                color: Colors.white,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class GroupIconButtons extends StatelessWidget {
  const GroupIconButtons({Key? key, this.isAdd, this.isDelete, this.isEdit})
      : super(key: key);

  final Function()? isAdd;
  final Function()? isEdit;
  final Function()? isDelete;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          IconButton(
              color: Color(0xFFFF8D7B),
              padding: EdgeInsets.all(2),
              onPressed: () => isAdd!(),
              icon: Icon(
                CupertinoIcons.plus_circle,
                size: 35,
              )),
          IconButton(
              color: Color(0xFFFF8D7B),
              padding: EdgeInsets.all(2),
              onPressed: () => isEdit!(),
              icon: Icon(
                CupertinoIcons.pencil_circle,
                size: 35,
              )),
          IconButton(
              color: Color(0xFFFF8D7B),
              padding: EdgeInsets.all(2),
              onPressed: () => isDelete!(),
              icon: Icon(
                CupertinoIcons.trash_circle,
                size: 35,
              )),
        ],
      ),
    );
  }
}

_customDialog(BuildContext context, IconData icon, String message, double width,
    Color color) {
  double? screenHeight, screenWidth;
  screenHeight = MediaQuery.of(context).size.height;
  screenWidth = MediaQuery.of(context).size.width;
  showDialog(
      context: context,
      builder: (context) {
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
                    child: Text(message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  Positioned(
                      top: screenHeight! * -.079,
                      child: Icon(
                        icon,
                        size: 65,
                        color: color,
                      ))
                ],
              ),
            ),
            onWillPop: null);
      });
}
