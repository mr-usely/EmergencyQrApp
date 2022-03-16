import 'package:flutter/material.dart';

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
