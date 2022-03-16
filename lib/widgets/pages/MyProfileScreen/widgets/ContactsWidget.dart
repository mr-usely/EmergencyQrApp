import 'package:emergency_app/widgets/Models/Contacts.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/MyProfileScreen.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/LoadingHolder.dart';
import 'package:flutter/material.dart';

class ContactsWidget extends StatelessWidget {
  const ContactsWidget(
      {Key? key, required this.contactInfo, required this.isLoading})
      : super(key: key);

  final List<Contacts>? contactInfo;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    String getInitials(String getInitial) => getInitial.isNotEmpty
        ? getInitial.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
        : '';
    return Container(
      padding: EdgeInsets.all(15),
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
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLoading!
              ? const LoadingHolder()
              : Column(
                  children: List.generate(
                      contactInfo!.length,
                      (index) => Row(
                            children: <ContactLists>[
                              ContactLists(
                                name:
                                    "${contactInfo![index].contactName!} (${contactInfo![index].contactRelation!})",
                                phoneNumber: contactInfo![index].phoneNumber!,
                                onTap: () {},
                                thumbnail: Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      getInitials(
                                          contactInfo![index].contactName!),
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
  }
}
