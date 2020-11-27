import 'package:flutter/material.dart';

Widget customRow(String title, String content) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 2.0,
      ),
      Container(
        width: 200,
        child: Text(content),
      )
    ],
  );
}
