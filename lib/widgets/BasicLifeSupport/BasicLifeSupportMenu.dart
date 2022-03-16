import 'package:emergency_app/widgets/BasicLifeSupport/BasicLifeSupportLists.dart';
import 'package:emergency_app/widgets/Models/BasicLifeSupport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicLifeSupportMenu extends StatelessWidget {
  const BasicLifeSupportMenu(
      {Key? key, required this.isTap, required this.onTap, this.list})
      : super(key: key);

  final bool? isTap;
  final Function()? onTap;
  final List<BasicLifeSupport>? list;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => onTap!(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Basic Life Support',
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
                Icon(
                  !isTap!
                      ? CupertinoIcons.chevron_forward
                      : CupertinoIcons.chevron_down,
                  size: 25,
                  color: Color(0xFFFF6961),
                )
              ],
            ),
          ),
          isTap! ? BasicLifeSupportLists(lists: list!) : Container()
        ],
      ),
    );
  }
}
