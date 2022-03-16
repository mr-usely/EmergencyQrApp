import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
