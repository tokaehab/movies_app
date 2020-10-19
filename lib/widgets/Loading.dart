import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 25,
            width: 25,
            margin: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }
}
