import 'package:flutter/material.dart';
import 'package:userCritiqs/Component/Widget.Review.dart';
import 'package:userCritiqs/controller/ReviewService.dart';
import 'package:userCritiqs/model/Review.dart';

import 'package:userCritiqs/screens/CommentScreen.dart';

class ReviewScreen extends StatefulWidget {
  final int itemId;
  final String description;

  ReviewScreen({
    @required this.itemId,
    @required this.description,
  });

  @override
  _ReviewScreenState createState() => _ReviewScreenState(
        itemId: itemId,
        description: description,
      );
}

class _ReviewScreenState extends State<ReviewScreen> {
  int itemId;
  String description;

  _ReviewScreenState({
    @required this.itemId,
    @required this.description,
  });
  final ReviewService _reviewService = ReviewService();
  Future<List<Review>> _reviews;
  final TextEditingController _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  _fetchReviews() {
    _reviews = _reviewService.getReviews(itemId);
  }

  Future<void> _loadReviews() async {
    setState(() {
      _fetchReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    void _showReviewSheet() async {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.only(
                  top: 20.0, left: 35.0, right: 35.0, bottom: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: TextField(
                      maxLines: 13,
                      controller: _bodyController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        hintText: "Add your Review",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async => _reviewService
                        .addReview(_bodyController.text, "edimo", itemId)
                        .then(
                          (_) => Navigator.of(context).pop(),
                        )
                        .then((_) => _bodyController.text = ""),
                    child: Container(
                      margin: EdgeInsets.only(top: 20.0),
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: Text(
                          "send",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ).then((_) => _loadReviews());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showReviewSheet(),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SafeArea(
              child: Container(
                color: Colors.deepPurple,
                padding: EdgeInsets.only(
                    left: 35.0, top: 10.0, bottom: 20.0, right: 35.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          description,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: FutureBuilder(
                  future: _reviews,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Review>> snapshot) {
                    if (snapshot.hasData) {
                      List<Review> reviews = snapshot.data;

                      return ListView(
                          padding: EdgeInsets.only(
                              top: 20.0, right: 35.0, left: 35.0, bottom: 20.0),
                          children: reviews
                              .map((Review review) => InkWell(
                                    onDoubleTap: () {
                                      print("Hello World");
                                    },
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CommentScreen(reviewId: review.id),
                                      ),
                                    ).then(
                                      (_) => _loadReviews(),
                                    ),
                                    child: wReview(
                                      context,
                                      review.authorId,
                                      review.body,
                                      review.numberOfComments.toString(),
                                    ),
                                  ))
                              .toList());
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
