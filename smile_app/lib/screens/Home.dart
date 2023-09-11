import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smile_app/connectiostring/api_connection.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smile_app/screens/Add_post.dart';
import 'package:smile_app/screens/ZoomableImageScreen.dart';

class HomeScreen extends StatefulWidget {
   final String user_id;

  const HomeScreen({required this.user_id});

  @override
  _HomeScreenState createState() => _HomeScreenState();

  static of(BuildContext context) {}
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> searchResults = [];
  bool loading = true;
  bool isCommentVisible = false;
  int selectedPostId = -1;
  TextEditingController commentController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  var apiAllUserUrl =Connection_String.get_all_post;
  ScrollController _postsScrollController = ScrollController();
  ScrollController _searchResultsScrollController = ScrollController();

  @override
  void dispose() {
    _postsScrollController.dispose();
    _searchResultsScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    fetchAndRefreshPosts();
  }
Future<void> fetchAndRefreshPosts() async {
    await fetchPosts();
    Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      if (!mounted) {
        timer.cancel(); 
        return;
      }
      await fetchPosts(); 
    });
  }
  
Future<void> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse(apiAllUserUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        posts = List<Map<String, dynamic>>.from(jsonData['data']);
        loading = false;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  } catch (error) {
    print('Error fetching posts: $error');
    setState(() {
      loading = false;
    });
  }
  Future.delayed(Duration(seconds: 5), () {
    if (mounted) {
      fetchPosts();
    }
  });
}


  void toggleCommentVisibility(String postId) {
    setState(() {
      isCommentVisible = !isCommentVisible;
      selectedPostId = isCommentVisible ? int.parse(postId) : -1;
    });
  }

  void searchPosts(String query) {
    setState(() {
      searchResults = posts
          .where((post) =>
              post['first_name']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              post['post_discriptions']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    setState(() {
      searchController.clear();
      searchResults.clear();
    });
  }

  Future<void> deletePost(int postId) async {
  try {
    final deleteUrl =
        Connection_String.delete_post + '?post_id=$postId&user_id=${widget.user_id}';
    final response = await http.delete(Uri.parse(deleteUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String dialogTitle;
      String dialogContent;

      if (responseData['success'] == true) {
        dialogTitle = 'Success';
        dialogContent = responseData['message'];
        fetchPosts(); // Refresh posts
      } else {
        dialogTitle = 'Error';
        dialogContent = responseData['message'];
      }
      showDialog(
        context: context,
        builder: (context) {
          final dialog = AlertDialog(
            title: Text(dialogTitle),
            content: Text(dialogContent),
          );
          
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });

          return dialog;
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error while deleting post'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      fetchPosts();
    }
  } catch (error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Error while deleting post: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    fetchPosts();
  }
}
Future<void> refreshPosts() async {
    await fetchPosts();
    Timer.periodic(Duration(seconds: 5), (Timer timer) async {
    if (!mounted) {
      timer.cancel(); 
      return;
    }
    await fetchPosts(); 
  });
  }

  Future<void> postComment(String comment) async {
    if (selectedPostId != -1) {
      try {
        const url =Connection_String.create_cmment;
        final response = await http.post(
          Uri.parse(url),
           // 'http://172.31.243.243/flutter_test_project_API/user_account/post_comment.php'
          body: {
            'user_id': widget.user_id, 
            'post_id': selectedPostId.toString(), 
            'comment': comment,
          },
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          if (responseData['success'] == true) {
            print("Comment posted successfully");
            fetchPosts(); // Refresh posts
            commentController.clear();
            toggleCommentVisibility('-1');
          } else {
            print("Failed to post comment");
          }
        } else {
          print("Error while posting comment");
        }
      } catch (error) {
        print('Error posting comment: $error');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Available post'),

              SizedBox(height: 20),
              TextField(
                controller: searchController,
                onChanged: searchPosts,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: clearSearch,
                        )
                      : null,
                ),
              ),
              if (searchResults.isNotEmpty)
              ListView.builder(
                controller: _searchResultsScrollController,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final post = searchResults[index];
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                          IconButton(
                    icon: Icon(Icons.close), 
                    onPressed: () {
                      Navigator.of(context).pop(); 
                    },
                  ),
                         ],
                        ),
                        ListTile(
                          title: Text(post['first_name']),
                          subtitle: Text(post['post_discriptions']),
                          onTap: () {
                            final mainIndex = posts.indexWhere(
                                (mainPost) => mainPost['post_id'] == post['post_id']);
                            if (mainIndex != -1) {
                              _postsScrollController.animateTo(
                                mainIndex * 100, 
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            }
                            clearSearch();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
               loading
                  ? CircularProgressIndicator()
                  : ListView.builder(
                      controller: _postsScrollController,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ZoomableImageScreen(
                                          imageUrl: post['post_image_url'], 
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 200,
                                    color: Colors.yellow,
                                    child: Center(
                                      child: Image.network(
                                        post['post_image_url'], 
                                        fit: BoxFit.cover,
                                        width: double.infinity, 
                                        height: 200,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      // width: 200,
                                      color: const Color.fromARGB(255, 151, 148, 144),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                            Text(
                                            "Owner Emotion: ${post['post_discriptions']}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ), 
                                          SizedBox(height: 5),
                                          Text(
                                            "Posted by: ${post['first_name']}",
                                            style: const TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                      icon: Icon(Icons.comment),
                                      onPressed: () {
                                        toggleCommentVisibility(post['post_id']);
                                      },
                                    ),
                                    
                                    // SizedBox(width: 20),
                                    Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: () async {
                                          // Send a POST request to your PHP API to like the post
                                          final response = await http.post(
                                            Uri.parse(Connection_String.like), // Replace with your PHP API endpoint for liking posts
                                            body: {
                                              'user_id': widget.user_id, 
                                              'post_id': post['post_id'], 
                                            },
                                          );

                                          if (response.statusCode == 200) {
                                            final responseData = json.decode(response.body);
                                            if (responseData['success'] == true) {
                                              // Like was successful, update the like count for the post locally
                                              setState(() {
                                                post['like_count'] = responseData['like_count'];
                                              });
                                            } else {
                                              // Handle the case where liking the post failed
                                            }
                                          } else {
                                            // Handle network or server errors
                                          }
                                        },
                                      ),
                                      Text('Likes: ${post['like_count']}'), // Display the like count
                                    ],
                                  )
                                  ,
                                      post['user_id'] == widget.user_id
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () {
                                              deletePost(int.parse(post['post_id']));
                                              },
                                            ),
                                          ],
                                        )
                                      : SizedBox(),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // SizedBox(width: 20),
                                    
                                  ],
                                ),
                                SizedBox(height: 20),
                                if (isCommentVisible && selectedPostId == int.parse(post['post_id']))
                                  Container(
                                    color: Color.fromARGB(255, 185, 181, 185),
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Comments:",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 4),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:
                                           post['comments'].map<Widget>((comment) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50)),
                                                  child: Center(
                                                    child: Image.network(
                                                      post['user_image_url'], 
                                                      fit: BoxFit.cover,
                                                      width: 40, 
                                                      height: 40,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(comment),
                                              ],
                                            );
                                          }).toList(),
                                        ),

                                        SizedBox(height: 10),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 16),
                                                child: TextFormField(
                                                  controller: commentController,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Write a comment before sending';
                                                    }
                                                    return null;
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: 'Write a comment...',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_formKey.currentState!.validate()) {
                                                    postComment(commentController.text);
                                                  }
                                                },
                                                child: Text('Send Comment'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                          },
      ),
    ],
    ),
        ),
      );
  }
}
