import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/ContactDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
