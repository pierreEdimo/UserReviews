import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userCritiqs/controller/AuthService.dart';

import 'package:userCritiqs/screens/ItemScreen.dart';
import 'package:userCritiqs/screens/HomeScreen.dart';
import 'package:userCritiqs/screens/LoginScreen.dart';
import 'package:userCritiqs/screens/myScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
        ),
        content: Text(
          text,
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<String> get jwtOrEmpty async {
    String token = await storage.read(key: "jwt");
    if (token == null) return "";
    return token;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            if (snapshot.data == "") return LoginScreen();
            return BottomNavigation();
          }),
    );
  }
}

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.fetchSingleUser();
  }

  final _widgetOptions = <Widget>[
    new HomeScreen(),
    new ItemScreen(),
    new MyScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: 'search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'me'),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.deepPurpleAccent.shade400,
        selectedItemColor: Colors.deepPurple,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
