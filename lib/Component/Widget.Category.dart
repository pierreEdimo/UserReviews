import 'package:flutter/material.dart';

Widget wCategory(String imageUrl, String name, String numberOfItems) {
  return Stack(
    children: <Widget>[
      Container(
        height: 230,
        width: 500,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(imageUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: 2,
                blurRadius: 3,
                offset: Offset(0, 2),
              )
            ]),
      ),
      Container(
        alignment: Alignment.center,
        width: 500,
        height: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(0, 0, 0, 0.4),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.bottomCenter,
        height: 230,
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
            Text(
              "$numberOfItems (items)",
              style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      )
    ],
  );
}
