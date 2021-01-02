import 'package:flutter/material.dart';

Widget wItem(
    String imageUrl, String name, String note, String numberOfReviews) {
  return Stack(
    children: [
      Container(
        height: 230,
        width: 400,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 2),
            )
          ],
        ),
      ),
      Container(
        alignment: Alignment.center,
        height: 230,
        width: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Color.fromRGBO(0, 0, 0, 0.4),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.topRight,
        child: Container(
          height: 60,
          width: 80,
          decoration: BoxDecoration(
            color: int.parse(note) < 10
                ? Colors.redAccent.shade400
                : Colors.greenAccent.shade400,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              '$note/20',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
      Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.bottomCenter,
        height: 230,
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                "$numberOfReviews (reviews) ",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
