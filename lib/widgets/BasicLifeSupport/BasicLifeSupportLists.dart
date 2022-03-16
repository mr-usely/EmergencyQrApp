import 'package:emergency_app/widgets/Models/BasicLifeSupport.dart';
import 'package:flutter/material.dart';

class BasicLifeSupportLists extends StatelessWidget {
  const BasicLifeSupportLists({Key? key, required this.lists})
      : super(key: key);

  final List<BasicLifeSupport>? lists;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
          children: List<Widget>.generate(
        lists!.length,
        (index) => Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.red[50], borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(lists![index].title!,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              Text(lists![index].description!,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Text.rich(TextSpan(
                text: lists![index].subDescription!,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    fontWeight: FontWeight.w500),
              ))
            ],
          ),
        ),
      )),
    );
  }
}
