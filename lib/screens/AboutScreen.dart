import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Container(
              alignment: Alignment.topLeft,
              height: 60.0,
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "UserCritics is an application that allows its users to search and Review their favorites movies , tv shows and video games. It has been designed by Pierre Patrice Edimo Nkoe, for more inforamtions, contact pedimonkoe@yahoo.com ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
