import 'package:flutter/material.dart';

class PathologiesLists extends StatelessWidget {
  const PathologiesLists(
      {Key? key, required this.sickness, this.medicine, this.listID})
      : super(key: key);

  final int? listID;
  final String? sickness;
  final List<String>? medicine;
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
        ],
      ),
    );
  }
}
