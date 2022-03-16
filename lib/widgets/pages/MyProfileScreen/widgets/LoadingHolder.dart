import 'package:flutter/material.dart';

class LoadingHolder extends StatelessWidget {
  const LoadingHolder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
    );
  }
}
