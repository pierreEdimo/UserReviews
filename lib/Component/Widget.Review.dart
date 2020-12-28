import 'package:flutter/material.dart';

Widget wReview(BuildContext context, String authorName, String reviewNote,
    String body, String numberOfComments) {
  return Container(
    width: 500,
    margin: EdgeInsets.only(bottom: 20.0),
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
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
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              authorName,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: Colors.redAccent.shade200,
              ),
              child: Center(
                child: Text(
                  reviewNote,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            body,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(Icons.comment),
                Text("  $numberOfComments comments".toString()),
              ],
            ),
            IconButton(
              icon: Icon(Icons.more_horiz_outlined),
              onPressed: () => print("Hello Comment ! "),
            )
          ],
        )
      ],
    ),
  );
}
