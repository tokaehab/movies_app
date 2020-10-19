import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  final String error;
  ErrorWidget(this.error);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          'Error: $error',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
