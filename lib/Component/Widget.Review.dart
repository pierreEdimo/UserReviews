import 'package:flutter/material.dart';

Widget wReview(BuildContext context, String authorId, String body,
    String numberOfComments) {
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
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage('assets/personImage.jpg'),
          ),
          title: Text(authorId),
        ),
        SizedBox(
          height: 15.0,
        ),
        Container(
          padding:
              EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
          child: Text(
            body,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.only(left: 25.0, right: 25.0),
          child: Container(
            child: Row(
              children: [
                Icon(Icons.comment),
                Text("  $numberOfComments comments".toString()),
              ],
            ),
          ),
        )
      ],
    ),
  );
}
