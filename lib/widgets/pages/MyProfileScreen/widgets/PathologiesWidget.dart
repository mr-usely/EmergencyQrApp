import 'package:emergency_app/widgets/Models/Pathologies.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/LoadingHolder.dart';
import 'package:emergency_app/widgets/pages/MyProfileScreen/widgets/PathologiesList.dart';
import 'package:flutter/material.dart';

class PathologiesWidget extends StatelessWidget {
  const PathologiesWidget(
      {Key? key, required this.pathologyList, required this.isLoading})
      : super(key: key);
  final List<Pathologies> pathologyList;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
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
              ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLoading!
              ? const LoadingHolder()
              : Column(
                  children: List.generate(
                      pathologyList.length,
                      (index) => PathologiesLists(
                          sickness: pathologyList[index].sickness,
                          medicine: pathologyList[index].medicines,
                          listID: pathologyList[index].accountID)),
                )
        ],
      ),
    );
  }
}
