import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error ${snapshot.error}',
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        var data =
            snapshot.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (
            context,
            index,
          ) {
            final post = data[index];

            return SingleChildScrollView(
              child: Container(
                margin:
                    EdgeInsetsGeometry.lerp(
                  const EdgeInsets.all(
                      8),
                  const EdgeInsets.all(
                      8),
                  10,
                ),
                height: 540,
                decoration:
                    BoxDecoration(
                  color:
                      const Color.fromARGB(
                    255,
                    255,
                    255,
                    255,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                          25),
                ),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets
                                    .all(
                                    8.0),
                            child:
                                Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  BoxDecoration(
                                shape:
                                    BoxShape.circle,
                                image:
                                    DecorationImage(
                                  image:
                                      NetworkImage(
                                    post[
                                        'profImage'],
                                  ),
                                  fit: BoxFit
                                      .cover,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            post[
                                'username'],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed:
                                () {
                              ScaffoldMessenger.of(
                                      context)
                                  .showSnackBar(
                                const SnackBar(
                                  content:
                                      Text(
                                    'Post Deleted',
                                  ),
                                ),
                              );
                            },
                            icon:
                                const Icon(
                              Icons
                                  .more_horiz,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        post[
                            'caption'],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 350,
                      height: 350,
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    25),
                        image:
                            DecorationImage(
                          image:
                              NetworkImage(
                            post[
                                'postUrl'],
                          ),
                          fit:
                              BoxFit.cover,
                        ),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceEvenly,
                      children: [
                        Icon(
                          Icons.favorite,
                        ),
                        Icon(
                          Icons.comment,
                        ),
                        Icon(
                          Icons.send,
                        ),
                        Icon(
                          Icons.bookmark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}