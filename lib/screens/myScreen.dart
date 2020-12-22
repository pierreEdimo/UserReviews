import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Review.dart';
import 'package:userCritiqs/controller/ReviewService.dart';
import 'package:userCritiqs/model/Review.dart';
import 'package:userCritiqs/screens/CommentScreen.dart';
import 'package:userCritiqs/screens/LoginScreen.dart';
import '../main.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final ReviewService _reviewService = ReviewService();
  Future<List<Review>> _reviews;

  _fetchReviews() {
    _reviews = _reviewService
        .getReviewsFromAuthor("beb9667f-ced1-4c43-b825-84b63c1a2002");
  }

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _fetchReviews();
    });
  }

  void _logout(BuildContext context) async {
    storage.delete(key: "jwt");
    storage.delete(key: "userId");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  void _showModalSheet() async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 130,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.black,
                        size: 18,
                      ),
                      title: Text(
                        'About',
                        style: TextStyle(color: Colors.black),
                      )),
                  ListTile(
                    onTap: () => _logout(context),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                      size: 18,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              child: Container(
                height: 60.0,
                color: Colors.deepPurple,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "My Reviews",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                          color: Colors.white,
                          onPressed: () => _showModalSheet(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                child: FutureBuilder(
                  future: _reviews,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Review>> snapshot) {
                    if (snapshot.hasData) {
                      List<Review> reviews = snapshot.data;

                      return RefreshIndicator(
                        onRefresh: _loadReviews,
                        child: ListView(
                            padding: EdgeInsets.all(20.0),
                            children: reviews
                                .map((Review review) => InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommentScreen(
                                              reviewId: review.id),
                                        ),
                                      ).then(
                                        (_) => _loadReviews(),
                                      ),
                                      child: wReview(
                                          context,
                                          review.authorId,
                                          review.body,
                                          review.numberOfComments.toString()),
                                    ))
                                .toList()),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
