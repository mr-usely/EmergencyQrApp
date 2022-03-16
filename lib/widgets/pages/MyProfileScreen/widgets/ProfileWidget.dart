import 'package:emergency_app/widgets/Global/Global.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/LoadingHolder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget(
      {Key? key,
      required this.isLoading,
      this.name,
      this.allergy,
      this.birthday,
      this.organDonor})
      : super(key: key);

  final bool? isLoading;
  final String? name;
  final String? birthday;
  final String? organDonor;
  final String? allergy;
  @override
  Widget build(BuildContext context) {
    Widget profileDetails(IconData icon, String text) => RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            WidgetSpan(
                child: Icon(
              icon,
              color: Color(0xFFFF6961),
              size: 20,
            )),
            WidgetSpan(
                child: SizedBox(
              width: 6,
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

    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
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
          ],
        ),
        SizedBox(
          height: 10,
        ),
        isLoading!
            ? LoadingHolder()
            : Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFE080),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          CupertinoIcons.person_alt,
                          size: 40,
                          color: Colors.white,
                        )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileDetails(CupertinoIcons.person, name!),
                            profileDetails(CupertinoIcons.gift_alt, birthday!),
                            profileDetails(
                                CupertinoIcons.heart_slash, organDonor!),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            profileDetails(CupertinoIcons.nosign, allergy!),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              )
      ]),
    );
  }
}
