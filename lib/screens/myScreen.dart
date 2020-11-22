import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Review.dart';
import 'package:userCritiqs/controller/ReviewService.dart';
import 'package:userCritiqs/model/Review.dart';
import 'package:userCritiqs/screens/CommentScreen.dart';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final ReviewService _reviewService = ReviewService();
  Future<List<Review>> _reviews;

  _fetchReviews() {
    _reviews = _reviewService.getReviewsFromAuthor("edimo");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 100,
              color: Colors.deepPurple,
              padding: EdgeInsets.only(left: 35.0, right: 35.0),
              child: Container(
                margin: EdgeInsets.only(top: 30.0),
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
                        onPressed: () => print("Hello World! "),
                      )
                    ],
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
                            padding: EdgeInsets.only(
                                top: 20.0,
                                right: 35.0,
                                left: 35.0,
                                bottom: 20.0),
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
