import 'package:flutter/material.dart';
import 'package:userCritiqs/controller/CommentService.dart';
import 'package:userCritiqs/main.dart';
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
    void _updateCommentSheet(String content, int id) async {
      TextEditingController _updateController = TextEditingController()
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
                    child: TextFormField(
                      maxLines: 13,
                      controller: _updateController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 10.0, top: 20.0, right: 10.0),
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        hintText: "updateComment",
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      _commentService
                          .updateComment(_updateController.text, id)
                          .then((_) => _loadComments())
                          .then((_) => Navigator.of(context).pop());
                    },
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
        },
      );
    }

    void _showCommentModal(
        String authorId, int id, String content, context) async {
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
                      onTap: () async => _commentService
                          .deleteComment(id)
                          .then((_) => _loadComments())
                          .then((_) => Navigator.of(context).pop()),
                      leading: Icon(
                        Icons.delete_outlined,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Delete Comment',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        Navigator.of(context).pop();
                        _updateCommentSheet(content, id);
                      },
                      leading: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      title: Text(
                        'Edit Comment',
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

    void _showCommentSheet() async {
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
                      onTap: () async {
                        var userId = await storage.read(key: "userId");
                        _commentService
                            .addComment(_bodyController.text, userId, reviewId)
                            .then((_) => Navigator.of(context).pop())
                            .then((_) => _bodyController.text = "");
                      },
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
            SafeArea(
              child: Container(
                height: 60,
                color: Colors.deepPurple,
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Container(
                  child: Center(
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

                        return comments.length < 1
                            ? Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Center(
                                  child: Text(
                                    "there are no Comments yet , please be the first !",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView(
                                padding: EdgeInsets.all(20.0),
                                children: comments
                                    .map(
                                      (Comment comment) => Container(
                                        width: 500,
                                        margin: EdgeInsets.only(bottom: 20.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                                  comment.author.userName,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 19),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons
                                                      .more_horiz_outlined),
                                                  onPressed: () =>
                                                      _showCommentModal(
                                                          comment.authorId,
                                                          comment.id,
                                                          comment.body,
                                                          context),
                                                )
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 20.0, bottom: 20.0),
                                              child: Text(
                                                comment.body,
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
