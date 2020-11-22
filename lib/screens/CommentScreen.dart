import 'package:flutter/material.dart';
import 'package:userCritiqs/controller/CommentService.dart';
import 'package:userCritiqs/model/Comment.dart';

class CommentScreen extends StatefulWidget {
  final int reviewId;

  CommentScreen({@required this.reviewId});
  @override
  _CommentScreenState createState() => _CommentScreenState(reviewId: reviewId);
}

class _CommentScreenState extends State<CommentScreen> {
  int reviewId;
  CommentService _commentService = CommentService();
  Future<List<Comment>> _comments;
  final TextEditingController _bodyController = TextEditingController();

  _fetchComments() {
    _comments = _commentService.getComments(reviewId);
  }

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _fetchComments();
    });
  }

  _CommentScreenState({@required this.reviewId});
  @override
  Widget build(BuildContext context) {
    void _showCommentSheet() async {
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
                          contentPadding: EdgeInsets.only(
                              left: 10.0, top: 20.0, right: 10.0),
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          hintText: "Comment",
                          hintStyle:
                              TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async => _commentService
                          .addComment(_bodyController.text, "edimo", reviewId)
                          .then((_) => Navigator.of(context).pop())
                          .then((_) => _bodyController.text = ""),
                      child: Container(
                        margin: EdgeInsets.only(top: 20.0),
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Text(
                            "send",
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }).then((_) => _loadComments());
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showCommentSheet(),
      ),
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
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            "Comments",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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
                        topRight: Radius.circular(10.0))),
                child: FutureBuilder(
                    future: _comments,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Comment>> snapshot) {
                      if (snapshot.hasData) {
                        List<Comment> comments = snapshot.data;

                        return ListView(
                          padding: EdgeInsets.only(
                              top: 20.0, right: 35.0, left: 35.0, bottom: 20.0),
                          children: comments
                              .map(
                                (Comment comment) => Container(
                                  width: 500,
                                  margin: EdgeInsets.only(bottom: 20.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              'assets/personImage.jpg'),
                                        ),
                                        title: Text("edimo"),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 25.0,
                                            right: 25.0,
                                            top: 10.0,
                                            bottom: 10.0),
                                        child: Text(
                                          comment.body,
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }

                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
