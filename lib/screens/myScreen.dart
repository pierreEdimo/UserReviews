import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:userCritiqs/controller/ReviewService.dart';

import 'package:userCritiqs/model/Review.dart';
import 'package:userCritiqs/screens/AboutScreen.dart';
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

  String userId;

  Future<List<Review>> _fetchReviews() async {
    userId = await storage.read(key: "userId");
    print('userId: $userId');
    return _reviewService.getReviewsFromAuthor(userId);
  }

  @override
  void initState() {
    super.initState();
    _reviews = _fetchReviews();
  }

  Future<void> _loadReviews() async {
    setState(() {
      _reviews = _fetchReviews();
    });
  }

  void _logout(BuildContext context) async {
    storage.delete(key: "jwt");
    storage.delete(key: "userId");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  void _updateReviewSheet(String content, int note, int id) async {
    TextEditingController _updateNoteController = TextEditingController()
      ..text = note.toString();
    TextEditingController _updateBodyController = TextEditingController()
      ..text = content;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Color(0xFF737373),
          child: Container(
            padding: EdgeInsets.all(20.0),
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
                  flex: 1,
                  child: TextFormField(
                    controller: _updateNoteController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    maxLines: 13,
                    controller: _updateBodyController,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (int.parse(_updateNoteController.text) >= 20) {
                      displayDialog(context, "Error",
                          "the Note should be inferior than 20 ");
                    } else if (_updateNoteController.text.isEmpty) {
                      displayDialog(context, "Error", "You should add a note");
                    } else if (_updateBodyController.text.isEmpty) {
                      displayDialog(
                          context, "Error", "you should fill the content box");
                    } else {
                      _reviewService
                          .updateReview(content, note, id)
                          .then((_) => _loadReviews())
                          .then((_) => Navigator.of(context).pop());
                    }
                  },
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
    );
  }

  void _showReviewModal(String authorId, int id, context, content, note) async {
    String userId = await storage.read(key: "userId");
    showModalBottomSheet(
      context: context,
      builder: (context) {
        if (authorId == userId) {
          return Container(
            color: Color(0xFF737373),
            height: 130,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () async => _reviewService
                        .deleteReview(id)
                        .then((_) => _loadReviews())
                        .then((_) => Navigator.of(context).pop()),
                    leading: Icon(
                      Icons.delete_outlined,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Delete Review',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      _updateReviewSheet(content, note, id);
                    },
                    leading: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Edit Review',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.flag_outlined,
                  color: Colors.black,
                ),
                title: Text('Report'),
              ),
            ),
          );
        }
      },
    );
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
                      onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutScreen()))
                          .then((_) => Navigator.of(context).pop()),
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
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Review> reviews = snapshot.data;

                    return reviews.length < 1
                        ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                "you haven't reviewed an article yet , please look for something you like , review it , comment it , enjoy yourself",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : ListView(
                            shrinkWrap: true,
                            primary: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.all(20.0),
                            children: reviews
                                .map(
                                  (Review review) => InkWell(
                                      onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen(
                                                reviewId: review.id,
                                              ),
                                            ),
                                          ).then(
                                            (_) => _loadReviews(),
                                          ),
                                      child: Container(
                                        width: 500,
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.8),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  review.author.userName,
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  width: 100,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    color:
                                                        review.reviewNote < 10
                                                            ? Colors.redAccent
                                                                .shade400
                                                            : Colors.greenAccent
                                                                .shade400,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      '${review.reviewNote.toString()}/20',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22,
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
                                              padding: EdgeInsets.only(
                                                  top: 20.0, bottom: 20.0),
                                              child: Text(
                                                review.body,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(Icons.comment),
                                                    Text(
                                                        "  ${review.numberOfComments.toString()} comments"
                                                            .toString()),
                                                  ],
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .more_horiz_outlined),
                                                  onPressed: () =>
                                                      _showReviewModal(
                                                          review.authorId,
                                                          review.id,
                                                          context,
                                                          review.body,
                                                          review.reviewNote),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                )
                                .toList(),
                          );
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
